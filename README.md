# Chests are bounded containers.

![Wooden chest (domed lid) with fittings, 17th c.](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Coffe_en_bois_du_beffroi_de_Bruges.jpg/1599px-Coffe_en_bois_du_beffroi_de_Bruges.jpg?20110916140257)

Many embedded systems do not support dynamic memory allocation, but sometimes you need to process variable-sized things. [Chests.Stacks](src/chests-stacks.ads) and [Chests.Ring_Buffers](src/chests-ring_buffers.ads) are generic packages that have a fixed Capacity and only use statically allocated memory.

## Getting Started
In your [Alire](https://alire.ada.dev/) crate's working directory, run
```
alr with chests
```

## Example
```ada
with Chests.Ring_Buffers;
with Ada.Text_IO;

procedure Example is
   package Character_Ring_Buffers is new Chests.Ring_Buffers
      (Element_Type => Character,
       Capacity     => 16);
   use Character_Ring_Buffers;

   Send_Message : constant String := "Hello";
   RB : Ring_Buffer;
begin
   --  Ensure that the buffer is initialized by clearing it
   Clear (RB);

   --  Pretend we're receiving these characters from a UART or something in an
   --  interrupt handler
   for Ch of Send_Message loop
      if not Is_Full (RB) then
         Append (RB, Ch);
      end if;
   end loop;

   --  Now back in the main thread, we've decided it's time to consume all of
   --  the characters in the buffer and convert the message to a string.
   declare
      Receive_Message : String (1 .. Length (RB));
   begin
      for I in Receive_Message'Range loop
         Receive_Message (I) := First_Element (RB);
         Delete_First (RB);
      end loop;
      Ada.Text_IO.Put_Line (Receive_Message);
   end;
end Example;
```

## Why not Ada.Containers.Bounded_Vectors?
The Ada standard library includes some bounded containers. Annex A recommends, but does not require, that implementations of those containers avoid dynamic allocation. Further, these packages depend on other units that are not available with minimal runtimes (aka. ZFP, Light, nostd). Chests have no external dependencies and should work with any Ada runtime.

## Performance
All Stack and Ring_Buffer operations are O(1) complexity.

## Concurrency
If you need multiple reader/writer concurrency with these data structures, the [atomic](https://alire.ada.dev/crates/atomic.html) crate contains locking primitives. For more advanced lock-free buffers, see [bbqueue](https://alire.ada.dev/crates/bbqueue).

### Ring_Buffers
The ring buffer can be modified concurrently as long as only one thread is modifying the head or tail of the buffer at a time. For example, you could have a writer calling `Append` and a reader calling `First_Element` and `Delete_First`. Make sure to check `not Is_Full` and `not Is_Empty` before performing these operations. `Clear` is not thread safe.

### Stacks
Stack operations are not atomic. Put a lock around it.

## Testing
The unit tests run with a [set of restrictions](tests/gnat.adc) that ensure these packages work in ZFP and -nostdlib environments. GNATcoverage reports 100% coverage at the stmt+mcdc level.

## Changelog

### 0.1.1
2022-04-17

- Removed `Chests.Stacks.Elements` due to questionable secondary stack usage
- `Element_Array` is now `with Pack`, considerably reducing memory consumption for small element types
- `Chests.Ring_Buffers` are now Atomic, with some limitations (see README)
- Unit tests with ZFP restrictions
- Added an example program
- GitHub Actions for CI
- README updates

### 0.1.0
2022-04-14

Initial release!
