--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Chests.Ring_Buffers is

   function Increment
      (I : Index_Type)
      return Index_Type
   is
   begin
      if I = Index_Type'Last then
         return Index_Type'First;
      else
         return I + 1;
      end if;
   end Increment;

   function Decrement
      (I : Index_Type)
      return Index_Type
   is
   begin
      if I = Index_Type'First then
         return Index_Type'Last;
      else
         return I - 1;
      end if;
   end Decrement;

   function Length
      (This : Ring_Buffer)
      return Natural
   is (This.Used);

   function Is_Full
      (This : Ring_Buffer)
      return Boolean
   is (This.Used = Capacity);

   function Is_Empty
      (This : Ring_Buffer)
      return Boolean
   is (This.Used = 0);

   function First_Element
      (This : Ring_Buffer)
      return Element_Type
   is (This.Elements (This.First));

   function Last_Element
      (This : Ring_Buffer)
      return Element_Type
   is (This.Elements (This.Last));

   procedure Prepend
      (This : in out Ring_Buffer;
       Item : Element_Type)
   is
   begin
      This.First := Decrement (This.First);
      This.Elements (This.First) := Item;
      This.Used := This.Used + 1;
   end Prepend;

   procedure Append
      (This : in out Ring_Buffer;
       Item : Element_Type)
   is
   begin
      This.Last := Increment (This.Last);
      This.Elements (This.Last) := Item;
      This.Used := This.Used + 1;
   end Append;

   procedure Delete_First
      (This : in out Ring_Buffer)
   is
   begin
      This.First := Increment (This.First);
      This.Used := This.Used - 1;
   end Delete_First;

   procedure Delete_Last
      (This : in out Ring_Buffer)
   is
   begin
      This.Last := Decrement (This.Last);
      This.Used := This.Used - 1;
   end Delete_Last;

   procedure Clear
      (This : in out Ring_Buffer)
   is
   begin
      This.First := Index_Type'First;
      This.Last := Index_Type'Last;
      This.Used := 0;
   end Clear;
end Chests.Ring_Buffers;
