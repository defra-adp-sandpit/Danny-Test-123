using Danny.Test.Api.Models;
using Danny.Test.Core.Entities;

using AutoMapper;

namespace Danny.Test.Api.AutoMapper;

public class AutoMapperProfile : Profile
{
    public AutoMapperProfile()
    {
        CreateMap<ItemRequest, Item>();
    }
}
