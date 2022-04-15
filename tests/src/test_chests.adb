with Ada.Assertions; use Ada.Assertions;
with Ada.Text_IO;

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
      Assert (Is_Empty (S), "Stack.Clear did not");
      Push (S, 1);
      Assert (not Is_Empty (S), "Not empty after pushing to stack");
      Assert (Length (S) = 1, "Incorrect Length after push");
      Push (S, 2);
      Push (S, 3);
      Assert (Is_Full (S), "Stack was not full after writing Capacity times");
      Pop (S, I);
      Assert (I = 3, "First item Popped out of stack was incorrect");
      Pop (S, I);
      Assert (I = 2, "Second Pop was incorrect");
      Assert (not Is_Empty (S) and not Is_Full (S), "Partial stack state was incorrect");
      I := Pop (S);
      Assert (I = 1, "Final Pop was incorrect");
      Assert (Is_Empty (S), "Stack not empty after popping all items");
   end;

   declare
      package Integer_Ring_Buffers is new Chests.Ring_Buffers
         (Element_Type => Integer,
          Capacity     => 3);
      use Integer_Ring_Buffers;
      RB : Ring_Buffer;
   begin
      Clear (RB);
      Assert (Is_Empty (RB), "Ring not empty after Clear");
      Append (RB, 1);
      Assert (not Is_Empty (RB) and not Is_Full (RB), "Partially full Ring returned incorrect state");
      Prepend (RB, 2);
      Append (RB, 3);
      Assert (Last_Element (RB) = 3, "Last_Element returned incorrect value");
      Assert (First_Element (RB) = 2, "First_Element returned incorrect value");
      Assert (Is_Full (RB), "Is_Full returned incorrect value");
      Assert (Length (RB) = 3, "Length of full ring was incorrect");
      Delete_First (RB);
      Assert (Length (RB) = 2, "Length did not decrease after Delete_First");
      Assert (First_Element (RB) = 1, "First element was incorrect after Delete_First");
      Delete_Last (RB);
      Assert (Last_Element (RB) = 1, "Last element was incorrect after Delete_Last");
      Delete_Last (RB);
      Assert (Is_Empty (RB), "Ring was not empty after deleting all items");
   end;

   Ada.Text_IO.Put_Line ("PASS");
end Test_Chests;
