# Enigma Machine

This project is a Ruby simulation of the Enigma encryption machine. It reproduces the core logic of the Enigma’s rotors, reflector, and plugboard to encrypt messages letter by letter.

---

## Overview

The Enigma machine works by passing each character through:
1. Plugboard swaps (simple letter substitutions)
2. A sequence of rotors, each shifting letters according to its configuration
3. A reflector, which reverses the signal path
4. The same rotors in reverse order
5. Another pass through the plugboard

Each rotor advances after every keypress, introducing polyalphabetic substitution that makes decryption difficult without the correct configuration.

---

## Components

### `Rotor`
Represents a single Enigma rotor.

- **Attributes:**
  - `arr` — internal wiring permutation (as an array of letters)
  - `@turns` — number of rotations performed
  - `@offset` — current positional offset
  - `@position` — rotor’s index or `"reflector"`

- **Key Methods:**
  - `update_offset` — rotates the rotor when its stepping condition is met.
  - `update_offset?` — determines whether a rotor should rotate based on its position and offset.

---

### `RotorSystem`
Represents the full encryption system, including all rotors, the reflector, and the plugboard.

- **Initialization:**
  ```ruby
  RotorSystem.new(rotor1_str, rotor2_str, reflector_str, plug_board)
