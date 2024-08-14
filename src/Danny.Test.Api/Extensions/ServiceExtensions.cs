using Danny.Test.Core.Interfaces;
using Danny.Test.Core.Services;

namespace Danny.Test.Api.Extensions;
public static class ServiceExtensions
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddTransient<IItemService, ItemService>();
        return services;
    }
}
