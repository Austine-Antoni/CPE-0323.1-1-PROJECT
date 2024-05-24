title project.asm
.model small
.stack 100h
.data
    nl db 10,13,'','$'
    welcome db 10,13,'Welcome to CAO File Handling Program!$'
    pwmess db 10,13,'Enter password:$'
    pass db 'caoproj'
    count dw 7,?,7 dup(0)
    correct db 10,13,'Proceed$'
    incorrect db 10,13,'Try again$'
    err db 10,13,'Invalid input. Try again.$'
    input_ins db 10,13,'Enter 1,2,3,4,5,6,9, or 0:$'
    ins db 50 dup(0)
    fname db 'first.txt',0
    floc db 'C:\emu8086\MyBuild\first.txt',0
    fhandle dw ?   
    msg db 10,13,'Enter the data: $'
    buffer db 100 dup('$') 
    length_buffer dw 0  
    createm db 10,13,'Success! first.txt file has been made.$' 
    msg_new db 10,13,'Enter 1 to create first.txt file $'
    msg_write db 10,13,'Enter 2 to write to file $'
    msg_read db 10,13,'Enter 3 to read from file $'
    msg_delete db 10,13,'Enter 4 to delete the file $'
    msg_clear db 10,13,'Enter 5 to clear the content of the file $' 
    dis_about1 db 10,13,'This program is developed to handle text file.$'
    dis_about2 db 10,13,'CAO | CPE 0323.1-1 | Est. 2024 $'
    dis_about3 db 10,13,'Antoni, Atencia, Bauyon, Mercado, Leonardo$'
    msg_sgout db 10,13,'Enter 6 to sign out $'
    msg_about db 10,13,'Enter 9 to display program information $'
    msg_terminate db 10,13,'Enter 0 to terminate the program $'
    del_mesg1 db 10,13,'File does not exist. Create a .txt file first.$'
    del_mesg2 db 10,13,'C:\emu8086\MyBuild\first.txt has been deleted.$' 
    read_msg db '$' 
    read_msg2 db 10,13,'Message: $'
    clear_msg db 10,13,'Success! Check the .txt file.$'
    file_ex db 10,13,'File already exists.$'
.code
    main proc 
        mov ax, @data
        mov ds, ax
        ;sets to video mode
        mov ax, 0600h 
        ;bg:cyan, fg:black
        mov bh, 0b0h 
        ;top left corner
        mov cx,0 
        ;bottom-right
        mov dx, 0184fh 
        int 10h 
         
        mov ah, 02h 
        mov bh,00h 
        mov dh, 10  ;row column 
        mov dl,34   ;column 34
        int 10h  
        
        mov dx, offset welcome
        mov ah, 09h
        int 21h     
        
        
        mov cx, count   ;follows the password count
        mov bx, offset pass
        
        mov dx, offset pwmess
        mov ah, 09h
        int 21h
       
  
      again:  
        mov ah, 08h ;read character from keyboard
        int 21h
        
        cmp al,[bx] ;compare the input with the password
        jne pass_error
        inc bx  ;increment the password pointer, if correct
        loop again
        
        mov dx, offset correct
        mov ah, 09h
        int 21h
        
       
       instruc:
        mov ah, 09h
        lea dx, nl
        int 21h 
        
         
        lea dx, msg_new
        mov ah, 09h
        int 21h 
        
        lea dx, msg_write
        mov ah, 09h
        int 21h 
        
        lea dx, msg_read
        mov ah, 09h
        int 21h
         
        lea dx, msg_delete
        mov ah, 09h
        int 21h
        
        lea dx, msg_clear
        mov ah, 09h
        int 21h
        
        lea dx, msg_sgout
        mov ah, 09h
        int 21h
         
        lea dx, msg_about
        mov ah, 09h
        int 21h
             
        lea dx, msg_terminate
        mov ah, 09h
        int 21h 
        
        lea dx, input_ins
        mov ah, 09h
        int 21h 
        
        ;conversion from hex to decimal
        mov ah, 01h
        int 21h
        mov ins, al
        sub al, '0'
        
        
        cmp al,1
        je new 
        
        cmp al,2
        je write 
        
        cmp al,3
        je read
        
        cmp al,4
        je delete
        
        cmp al,5
        je clear 
        
        cmp al,6
        je sgout
        
        cmp al,9
        je about
        
        cmp al,0
        je terminate
        
        jne error
     main endp   
        
         
       new: 
        ;checking if the file exists
        mov dx,offset floc 	 				
        mov ah,4eh
        int 21h
        jc make_new 
        jmp fil_exis
        make_new:
        ;new file 
        mov ah,3ch
        lea dx,fname 
        mov cl,0
        int 21h  
        mov fhandle,ax 
        ;display message
        mov dx, offset createm
        mov ah, 09h
        int 21h
        ;close the file
        mov ah,3eh
        mov bx, fhandle
        int 21h
        jmp instruc
       
       
       read:
            ;confirm existence of file
            mov dx,offset floc 	 				
            mov ah,4eh
            int 21h
            jc del_notfound
            jmp read_again
           read_again: 
            ;open
            mov ah,3dh
            lea dx, floc
            mov al,0
            int 21h
            mov fhandle,ax
            ;read
            mov ah, 3fh 
            lea dx, buffer
            mov cx, 100
            mov bx, fhandle 
            int 21h
            ;new line and display message
            mov ah, 09h
            lea dx, read_msg
            int 21h
            ;display 
            lea dx, read_msg2
            mov ah,09h
            int 21h 
            lea dx, buffer
            mov ah, 09h
            int 21h  
            ;close the file
            mov ah,3eh
            mov bx, fhandle
            int 21h 
            jmp instruc 
            
       delete:   
            ;confirm existence of file
            mov dx,offset floc 	 				
            mov ah,4eh
            int 21h
            jc del_notfound
            mov cx, 5 
           loop_del:
            ;delete the file
            mov dx, offset floc
            mov ah, 41h            
            int 21h 
            dec cx
            jnz loop_del
            ;display message
            lea dx, del_mesg2
            mov ah, 09h
            int 21h
            jmp instruc  
                
       write: 
            ;confirm existence of file
            mov dx,offset floc 	 				
            mov ah,4eh
            int 21h
            jc del_notfound
            jmp write_again
           write_again: 
            ;open the file
            mov ah, 3dh 
            lea dx, fname
            mov al,2
            int 21h
            mov fhandle, ax 
            ;display message
            lea dx, msg
            mov ah, 09h
            int 21h 
            ;read the input string
            mov si,0
            mov cx,0
         again1:
            ;read a character from keyboard   
            mov ah,01h
            int 21h 
            ;identifies if the user pressed 'Enter'
            cmp al,13
            je exit 
            ;store the character/s to the buffer array
            mov buffer[si],al   
            inc si
            inc cx
            jmp again1 
            ;write the input string to the file 
         exit:
            ;write to a file
            mov ah,40h
            mov bx,fhandle
            lea dx, buffer 
            ;mov cx, si
            int 21h
            mov ah,40h
            mov bx,fhandle
            lea dx, nl 
            ;mov cx, si
            int 21h  
         ;close the file
            mov ah,3eh
            mov bx, fhandle
            int 21h  
            jmp instruc 
            
        clear:
            ;confirm existence of file
            mov dx,offset floc 	 				
            mov ah,4eh
            int 21h
            jc del_notfound 
            jmp over
            ;overwrite file by creating the same file
           over:
            mov ah, 3ch
            mov cx, 0
            lea dx, fname
            int 21h
            mov fhandle, ax
            jc over
            jmp close 
            ;close
           close:
            mov ah, 3eh
            mov bx, fhandle
            int 21h  
            ;display message
            mov ah, 09h
            lea dx, clear_msg
            int 21h
            jmp instruc   
            
        about:
            lea dx, dis_about1
            mov ah, 09h
            int 21h 
            lea dx, dis_about2
            mov ah, 09h
            int 21h
            lea dx, dis_about3
            mov ah, 09h
            int 21h
            jmp instruc
       
       sgout:
        jmp main
             
       pass_error:
        mov dx, offset incorrect
        mov ah, 09h
        int 21h
        jmp main
        
       error: 
        mov dx, offset err
        mov ah, 09h
        int 21h
        jmp instruc
       
       del_notfound:
        mov dx, offset del_mesg1
        mov ah, 09h
        int 21h
        jmp instruc
        
       fil_exis:
        mov dx, offset file_ex
        mov ah, 09h
        int 21h
        jmp instruc 
        
       terminate:   
        mov ah,4ch
        int 21h
        
        
    end main




