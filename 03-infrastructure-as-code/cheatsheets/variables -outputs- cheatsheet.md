# Variables & Outputs Cheatsheet

## Variable Types:

1. **string**: "text"
2. **number**: 42
3. **bool**: true/false
4. **list**: ["a", "b", "c"]
5. **map**: {key = "value"}
6. **set(string)**: ["a", "b"]
7. **object({})**: {name = string, age = number}
8. **tuple([])**: [string, number, bool]

## Variable Features:

- description: "What this variable is for"
- default: Default value
- type: Data type
- validation: Custom validation rules
- sensitive: Hide value in output

## Output Best Practices:

- Always add description
- Output useful information
- Use for_each with complex structures
- Group related outputs

## Locals Usage:

- Reuse expressions
- Complex calculations
- Common tags/names
- Avoid repetition

🔗 **Additional Resources**

- [Variable Configuration](https://developer.hashicorp.com/terraform/language/values/variables)
- [Output Configuration](https://developer.hashicorp.com/terraform/language/values/outputs)
- [Local Values](https://developer.hashicorp.com/terraform/language/values/locals)
- [Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)