Please add a new changelog entry with context about our latest work. Be sure to also update the version in `info.json`.

$ARGUMENTS

The changelog should only contain details that are relevant to players and users of the mod; it should not contain details specific to the development process or repo management.

Factorio's Change Log Specification:

```
---------------------------------------------------------------------------------------------------
Version: X.Y.Z
Date: DD. MM. YYYY
  Changes:
    - Change description here
    - Another change description
  Bugfixes:
    - Bug fix description
    - Another bug fix
  Features:
    - New feature description
  Minor Features:
    - Small feature addition
  Graphics:
    - Graphics-related changes
  Sounds:
    - Audio-related changes
  Optimizations:
    - Performance improvements
  Balancing:
    - Game balance changes
  Combat:
    - Combat-related changes
  Circuit Network:
    - Circuit network changes
  Copy-paste:
    - Copy-paste functionality changes
  Trains:
    - Train-related changes
  GUI:
    - User interface changes
  Control:
    - Control/input changes
  Translation:
    - Localization changes
  Modding:
    - Modding API changes
  Scripting:
    - Scripting changes
  Ease of use:
    - Quality of life improvements
```

Important Guidelines

- Entries must map to an official factorio category.
- Use simple, clear language that focuses on the user benefit rather than technical implementation details
- Don't include low level details that are only specific to our mod, such as internal variable names, file structure changes, etc.
- Use positive, forward-looking language that describes what the changes accomplish.
- Prefer algorithmic descriptions over code-specific or internal terms ("algorithm" vs "validation function")

Examples:
- Good: "Optimized search algorithm by using hash tables instead of linear scanning"
- Less good: "Improved performance of should_exclude_entity() by replacing array iteration with direct table lookup"

Iterate a few times to come up with the clearest message. This changelog is important for representing our work.