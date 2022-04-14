with Ada.Assertions; use Ada.Assertions;
with Chests.Ring_Buffers;
with Chests.Stacks;

procedure Test_Chests is
begin
   declare
      package Integer_Stacks is new Chests.Stacks
         (Element_Type => Integer,
          Capacity     => 3);
      use Integer_Stacks;
      S : Stack;
      I : Integer;
   begin
      Clear (S);
      Assert (Is_Empty (S));
      Push (S, 1);
      Assert (not Is_Empty (S));
      Assert (Length (S) = 1);
      Push (S, 2);
      Push (S, 3);
      Assert (Elements (S) = Element_Array'(1, 2, 3));
      Assert (Is_Full (S));
      Pop (S, I);
      Assert (I = 3);
      Pop (S, I);
      Assert (I = 2);
      Assert (not Is_Empty (S) and not Is_Full (S));
      I := Pop (S);
      Assert (I = 1);
      Assert (Is_Empty (S));
   end;

   declare
      package Integer_Ring_Buffers is new Chests.Ring_Buffers
         (Element_Type => Integer,
          Capacity     => 3);
      use Integer_Ring_Buffers;
      RB : Ring_Buffer;
   begin
      Clear (RB);
      Assert (Is_Empty (RB));
      Append (RB, 1);
      Assert (not Is_Empty (RB) and not Is_Full (RB));
      Prepend (RB, 2);
      Append (RB, 3);
      Assert (Last_Element (RB) = 3);
      Assert (First_Element (RB) = 2);
      Assert (Is_Full (RB));
      Assert (Length (RB) = 3);
      Delete_First (RB);
      Assert (Length (RB) = 2);
      Assert (First_Element (RB) = 1);
      Delete_Last (RB);
      Assert (Last_Element (RB) = 1);
      Delete_Last (RB);
      Assert (Is_Empty (RB));
   end;
end Test_Chests;
