# Infrastructure-as-Code

**File Name:** `puppet_ast_typeset.pp`

---

**README: Puppet AST Typeset**

## Overview

This Puppet module provides a custom data type set (`TypeSet`) that defines a collection of Puppet Abstract Syntax Tree (AST) elements. These elements represent various constructs used in Puppet manifests.

## Contents

- `pcore_version`: The version of the Puppet Core associated with this AST typeset.

### Types

1. `Locator`
   - Attributes:
     - `string`: String
     - `file`: String
     - `line_index`: Optional Array of Integers (default: undefined)

2. `PopsObject`

3. `Positioned`
   - Attributes:
     - `parent`: PopsObject
     - `locator`: Locator (reference)
     - `offset`: Integer
     - `length`: Integer
     - `file`: String (derived)
     - `line`: Integer (derived)
     - `pos`: Integer (derived)

... (and so on)

## Usage

To use this module, include it in your Puppet environment. You can then utilize the provided custom types and their respective attributes within your Puppet manifests.

```puppet
include puppet_ast_typeset

puppet_ast_typeset::Locator {
  string => 'example_string',
  file   => 'example_file',
  line_index => [1, 2, 3],
}
```

## Notes

- Ensure that you have the required version of Puppet Core installed in your environment to use this module effectively.

---

This README provides an overview of the Puppet AST Typeset module and outlines the structure and usage of the custom data types. It also includes an example of how to use the `Locator` type with its attributes. Make sure to replace the placeholder content with actual information specific to your module.

**File Name:** `puppet_ast_typeset.pp`
