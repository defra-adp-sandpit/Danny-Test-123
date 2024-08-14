ARG PARENT_VERSION=1.7.0-dotnet8.0

# Development
FROM defradigital/dotnetcore-development:${PARENT_VERSION} AS development
ARG PARENT_VERSION
LABEL uk.gov.defra.ffc.parent-image=defradigital/dotnetcore-development:${PARENT_VERSION}

COPY --chown=dotnet:dotnet ./Directory.Build.props ./Directory.Build.props
RUN mkdir -p /home/dotnet/src/Danny.Test.Api/
WORKDIR /home/dotnet/src
COPY --chown=dotnet:dotnet ./src/Danny.Test.Api/*.csproj ./Danny.Test.Api/
COPY --chown=dotnet:dotnet ./src/Danny.Test.Core/*.csproj ./Danny.Test.Core/
RUN dotnet restore "./Danny.Test.Core/Danny.Test.Core.csproj"
RUN dotnet restore "./Danny.Test.Api/Danny.Test.Api.csproj"

# some CI builds fail with back to back COPY statements, eg Azure DevOps
RUN true
COPY --chown=dotnet:dotnet ./src/Danny.Test.Api/ ./Danny.Test.Api/
COPY --chown=dotnet:dotnet ./src/Danny.Test.Core/ ./Danny.Test.Core/

RUN chown -R dotnet:dotnet /home/dotnet

WORKDIR /home/dotnet/src/Danny.Test.Api
RUN dotnet publish -c Release -o /home/dotnet/out

ARG PORT=3007
ENV PORT ${PORT}
EXPOSE ${PORT}
# Override entrypoint using shell form so that environment variables are picked up
ENTRYPOINT dotnet watch --project Danny.Test.Api.csproj run --urls "http://*:${PORT}"

# Production
FROM defradigital/dotnetcore:${PARENT_VERSION} AS production
ARG PARENT_VERSION
LABEL uk.gov.defra.ffc.parent-image=defradigital/dotnetcore:${PARENT_VERSION}
COPY --from=development /home/dotnet/out/ ./
ARG PORT=3007
ENV ASPNETCORE_URLS http://*:${PORT}
EXPOSE ${PORT}
# Override entrypoint using shell form so that environment variables are picked up
ENTRYPOINT dotnet Danny.Test.Api.dll
