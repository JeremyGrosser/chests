--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Chests.Stacks is

   function Is_Full
      (S : Stack)
      return Boolean
   is (S.Last = Capacity);

   function Is_Empty
      (S : Stack)
      return Boolean
   is (S.Last = 0);

   function Length
      (S : Stack)
      return Natural
   is (S.Last);

   procedure Push
      (S    : in out Stack;
       Item : Element_Type)
   is
   begin
      S.Last := S.Last + 1;
      S.Items (S.Last) := Item;
   end Push;

   procedure Pop
      (S    : in out Stack;
       Item : out Element_Type)
   is
   begin
      Item := S.Items (S.Last);
      S.Last := S.Last - 1;
   end Pop;

   function Pop
      (S : in out Stack)
      return Element_Type
   is
      Item : Element_Type;
   begin
      Pop (S, Item);
      return Item;
   end Pop;

   procedure Clear
      (S : in out Stack)
   is
   begin
      S.Last := 0;
   end Clear;

end Chests.Stacks;
