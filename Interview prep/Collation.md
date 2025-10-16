# What is Collation

**Simplified Definition:**  
Collation is a set of rules that tells a database how to compare and sort text, including handling differences in case ("A" vs. "a") and accents ("e" vs. "é").

**Enhanced Explanation:**  
Collation refers to the rules and algorithms used to compare and sort characters in a database. It determines:

- The order of characters
- How case sensitivity is treated (e.g., "A" vs. "a")
- How accents and special characters are handled

Collation is important because it affects how queries run and how results are sorted. Incorrect collation settings can lead to wrong query results or improper data sorting.

---

## Types of Collation (Examples)

1. **Binary:**  
   - Compares strings byte by byte  
   - Case-sensitive and accent-sensitive

2. **Case-insensitive:**  
   - Ignores case differences  
   - Accent-sensitive

3. **Accent-insensitive:**  
   - Ignores accents (e.g., "café" and "cafe" are the same)  
   - Case-sensitive

4. **Case- and accent-insensitive:**  
   - Ignores both case and accents

5. **Unicode:**  
   - Supports many languages and characters  
   - Available in multiple variants, such as `utf8mb4_unicode_ci`, `utf8mb4_unicode_520_ci`, etc.

---

**Summary:**  
Collation controls how text is compared and sorted in a database. Choosing the right collation ensures accurate queries and sorting, especially with different languages or special characters.