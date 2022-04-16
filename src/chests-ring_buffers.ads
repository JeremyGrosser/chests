--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
generic
   type Element_Type is private;
   Capacity : Positive := 1;
package Chests.Ring_Buffers
   with Preelaborate
is
   type Ring_Buffer is private;

   function Length
      (This : Ring_Buffer)
      return Natural;

   function Is_Full
      (This : Ring_Buffer)
      return Boolean;

   function Is_Empty
      (This : Ring_Buffer)
      return Boolean;

   function First_Element
      (This : Ring_Buffer)
      return Element_Type
   with Pre => not Is_Empty (This);

   function Last_Element
      (This : Ring_Buffer)
      return Element_Type
   with Pre => not Is_Empty (This);

   procedure Prepend
      (This : in out Ring_Buffer;
       Item : Element_Type)
   with Pre  => not Is_Full (This),
        Post => Length (This) = Length (This'Old) + 1;

   procedure Append
      (This : in out Ring_Buffer;
       Item : Element_Type)
   with Pre  => not Is_Full (This),
        Post => Length (This) = Length (This'Old) + 1;

   procedure Delete_First
      (This : in out Ring_Buffer)
   with Pre  => not Is_Empty (This),
        Post => Length (This) = Length (This'Old) - 1;

   procedure Delete_Last
      (This : in out Ring_Buffer)
   with Pre  => not Is_Empty (This),
        Post => Length (This) = Length (This'Old) - 1;

   procedure Clear
      (This : in out Ring_Buffer)
   with Post => Is_Empty (This);

private
   type Index_Type is new Positive range 1 .. Capacity;
   function Increment (I : Index_Type) return Index_Type;
   function Decrement (I : Index_Type) return Index_Type;
   --  Array indicies cannot be a modular type, so we do overflow logic inside
   --  Increment and Decrement.

   type Element_Array is array (Index_Type) of Element_Type
      with Pack;

   type Ring_Buffer is record
      Elements : Element_Array;
      First    : Index_Type := Index_Type'First;
      Last     : Index_Type := Index_Type'Last;
      Used     : Natural := 0 with Atomic;
   end record;
end Chests.Ring_Buffers;
