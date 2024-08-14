using System.ComponentModel.DataAnnotations;

namespace Danny.Test.Api.Models;

public class ItemRequest
{
    public int? Id { get; set; }
    [Required]
    public required string Name { get; set; }
}

