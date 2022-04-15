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

   --  Pretend we're receiving these characters in a UART interrupt handler
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
