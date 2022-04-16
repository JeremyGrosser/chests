--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
generic
   type Element_Type is private;
   Capacity : Positive := 1;
package Chests.Stacks
   with Preelaborate
is
   type Stack is private;

   function Is_Full
      (S : Stack)
      return Boolean;

   function Is_Empty
      (S : Stack)
      return Boolean;

   function Length
      (S : Stack)
      return Natural;

   procedure Push
      (S    : in out Stack;
       Item : Element_Type)
   with Pre  => not Is_Full (S),
        Post => Length (S) = Length (S'Old) + 1;

   procedure Pop
      (S    : in out Stack;
       Item : out Element_Type)
   with Pre  => not Is_Empty (S),
        Post => Length (S) = Length (S'Old) - 1;
   --  Last In, First Out (LIFO)

   function Pop
      (S : in out Stack)
      return Element_Type
   with Pre  => not Is_Empty (S),
        Post => Length (S) = Length (S'Old) - 1;

   procedure Clear
      (S : in out Stack);

private

   type Element_Array is array (1 .. Capacity) of Element_Type
      with Pack;

   type Stack is record
      Items : Element_Array;
      Last  : Natural := 0;
   end record;

end Chests.Stacks;
