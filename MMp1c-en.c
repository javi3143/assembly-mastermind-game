/**
 * C-Implementation of the practice, to have a high-level 
 * functional version with all the features you have to implement 
 * in assembly language.
 * From this code calls are made to assembly subroutines. 
 * THIS CODE CANNOT BE MODIFIED AND SHOULD NOT BE DELIVERED. 
 */
 
#include <stdio.h>
#include <termios.h>    //termios, TCSANOW, ECHO, ICANON
#include <unistd.h>     //STDIN_FILENO

/**
 * Constants.
 */
#define ARRAYDIM 5

/**
 * Global variables definition
 */
extern int developer;	 //Declared variable in assembly language indicating the program developer name.

char charac;   //Character read from the keyboard and to show.
int  row;	   //Row of the screen where the cursor is placed.
int  col;	   //Column of the screen where the cursor is placed.

int  aSecret[ARRAYDIM] = {-3,-3,-3,-3,-3};   //Secret Code.
int  aPlay[ARRAYDIM]   = {0,0,0,0,0};        //Try.
int  pos;      //Position inside the array the we are accessing and position of the cursor on the game board.

short state;   //State of the game.
               //0: We are typing the secret code. 
               //1: We are typing a tray.
               //2: The secret code has the initial values or repeted values.
               //3: Won, try = secret code.
               //4: The tries have run out.
               //5: Press ESC to exit
int   tries;   //Remaining tries.
short hX;      //Hits in place.


/**
 * Definition of C functions.
 */
void clearScreen_C();
void gotoxyP1_C();
void printchP1_C();
void getchP1_C();
void printMenuP1_C();
void printBoardP1_C();
void posCurBoardP1_C();
void updatePosP1_C();
void updateArrayP1_C();
void checkSecretP1_C();
void printSecretPlayP1_C();
void checkPlayP1_C();
void printHitsP1_C();
void printMessageP1_C();
void playP1_C();

/**
 * Definition of assembly language subroutines called from C.
 */
void posCurBoardP1();
void updatePosP1();
void updateArrayP1();
void checkSecretP1();
void printSecretPlayP1();
void checkPlayP1();
void printHitsP1();
void playP1();


/**
 * Clear screen.
 * 
 * Global variables used:	
 * None
 * 
 * This function is not called from assembly code
 * and an equivalent assembly subroutine is not defined.
 */
void clearScreen_C(){
	
    printf("\x1B[2J");
    
}


/**
 * Place the cursor at a position on the screen.
 * 
 * Global variables used:	
 * (row) : Row of the screen where the cursor is placed.
 * (col) : Column of the screen where the cursor is placed.
 * 
 * An assembly language subroutine 'gotoxyP1' is defined to be able 
 * to call this function saving the status of the processor registers. 
 * This is done because C functions do not maintain the status of 
 * the processor registers.
 */
void gotoxyP1_C(){
	
   printf("\x1B[%d;%dH", row, col);
   
}


/**
 * Show a character on the screen at the cursor position.
 * 
 * Global variables used:	
 * (charac) : Character to show.
 * 
 * An assembly language subroutine 'printchP1' is defined to be able 
 * to call this function saving the status of the processor registers. 
 * This is done because C functions do not maintain the status of 
 * the processor registers. The parameters are equivalent.
 */
void printchP1_C(){
	
   printf("%c",charac);
   
}


/**
 * Read a character from the keyboard without displaying it 
 * on the screen and store it in the variable (charac).
 * 
 * Global variables used:	
 * (charac) : Character read from the keyboard.
 * 
 * An assembly language subroutine 'getchP1' is defined to be able 
 * to call this function saving the status of the processor registers. 
 * This is done because C functions do not maintain the status of 
 * the processor registers. The parameters are equivalent.
 */
void getchP1_C(){

   static struct termios oldt, newt;

   /*tcgetattr get terminal parameters
   STDIN_FILENO indicates that standard input parameters (STDIN) are written on oldt*/
   tcgetattr( STDIN_FILENO, &oldt);
   /*copy parameters*/
   newt = oldt;

   /* ~ICANON to handle keyboard input character to character, not as an entire line finished with /n
      ~ECHO so that it does not show the character read*/
   newt.c_lflag &= ~(ICANON | ECHO);          

   /*Fix new terminal parameters for standard input (STDIN)
   TCSANOW tells tcsetattr to change the parameters immediately.*/
   tcsetattr( STDIN_FILENO, TCSANOW, &newt);

   /*Read a character*/
   charac=(char)getchar();                 
    
   /*restore the original settings*/
   tcsetattr( STDIN_FILENO, TCSANOW, &oldt);
   
}


/**
 * Show the game menu on the screen and ask for an option.
 * Only accepts one of the correct menu options ('0'-'9').
 * 
 * Global variables used:	
 * (row)       : Row of the screen where the cursor is placed.
 * (col)       : Column of the screen where the cursor is placed.
 * (charac)    : Character read from the keyboard.
 * (developer) :((char *)&developer):Variable defined in the assembly code.
 * 
 * This function is not called from the assembly code and 
 * an equivalent subroutine has not been defined in assembly language.
 */
void printMenuP1_C(){
	
	clearScreen_C();
    row = 1;
    col = 1;
    gotoxyP1_C();
    printf("                              \n");
    printf("       Developed by:          \n");
	printf("     ( %s )   \n",(char *)&developer);
    printf(" ____________________________ \n");
    printf("|                            |\n");
    printf("|      MENU MASTERMIND       |\n");
    printf("|____________________________|\n");
    printf("|                            |\n");
    printf("|       1. PosCurBoard       |\n");
    printf("|       2. UpdatePos         |\n");
    printf("|       3. UpdateArray       |\n");
    printf("|       4. CheckSecret       |\n");
    printf("|       5. PrintSecretPlay   |\n");
    printf("|       6. PrintHits         |\n");
    printf("|       7. CheckPlay         |\n");
    printf("|       8. Play Game         |\n");
    printf("|       9. Play Game C       |\n");
    printf("|       0. Exit              |\n");
    printf("|                            |\n");
    printf("|          OPTION:           |\n");
    printf("|____________________________|\n"); 

    charac=' ';
    while (charac < '0' || charac > '9') {
      row = 20;
      col = 20;
      gotoxyP1_C();
	  getchP1_C();
	}
	
}


/**
 * Show the game board on the screen. Lines of the board.
 * 
 * Global variables used:
 * (row)   : Row of the screen where the cursor is placed.
 * (col)   : Column of the screen where the cursor is placed.
 * (tries) : Remaining tries.
 * 
 * This function is not called from the assembly code and 
 * an equivalent subroutine has not been defined in assembly language.
 */
void printBoardP1_C(){
   int i;

   clearScreen_C();
   row = 1;
   col = 1;
   gotoxyP1_C();
   printf(" _______________________________ \n");//1
   printf("|                               |\n");//2
   printf("|      _ _ _ _ _   Secret Code  |\n");//3
   printf("|_______________________________|\n");//4
   printf("|                 |             |\n");//5
   printf("|       Play      |     Hits    |\n");//6
   printf("|_________________|_____________|\n");//7
   for (i=0;i<tries;i++){                        //8-19
     printf("|   |             |             |\n");
     printf("| %d |  _ _ _ _ _  |  _ _ _ _ _  |\n",i+1);
   }
   printf("|___|_____________|_____________|\n");//20
   printf("|       |                       |\n");//21
   printf("| Tries |                       |\n");//22
   printf("|  ___  |                       |\n");//23
   printf("|_______|_______________________|\n");//24
   printf(" (ENTER) next Try       (ESC)Exit \n");//25
   printf(" (0-9) values    (j)Left (k)Right   ");//26
   
}
   

/**
 * Place the cursor inside the board according to the position of 
 * the cursor (pos) and the remaining tries (tries). 
 * If we are typing the secret code (status==0) we will place 
 * the cursor in row 3 (row=3), if we are typing a try (status!=0) 
 * the row is calculated with the formula: (row=9+(ARRAYDIM-tries)*2).
 * The column is calculated with the formula (col= 8+(pos*2)).
 * Place the cursor calling the gotoxyP1_C function.
 * 
 * Global variables used:	
 * (state) : State of the game.
 * (tries) : Remaining tries.
 * (row)   : Row of the screen where the cursor is placed.
 * (col)   : Column of the screen where the cursor is placed.
 * (pos)   : The place where the cursor is.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'posCurBoardP2' is defined.
 */
void posCurBoardP1_C(){
	
   if (state==0) {
      row = 3;
   } else {
      row = 9+(ARRAYDIM-tries)*2;
   }
   col = 8+(pos*2);
   
   gotoxyP1_C();
   
}

/**
 * If we have read (charac=='j') left or (charac=='k') right, update 
 * the place of the cursor, index of the array of the combination, 
 * checking that does not exit the positions of the array [0..4] and 
 * update the index of the array (pos +/-1) as appropriate.
 * You cannot go out from the area where we are typing (5 positions).
 * 
 * Global variables used:	
 * (charac) : Character read from the keyboard.
 * (pos)    : The place where the cursor is.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'updatePosP1' is defined.
 */
void updatePosP1_C(){
	
   if ((charac=='j') && (pos>0)){             
      pos--;
   }
   if ((charac =='k') && (pos<ARRAYDIM-1)){
      pos++;
   }
   
}


/**
 * Store the value of the read character ['0' - '9'] in the array and 
 * show it on the screen.
 * Get the value (val) subtracting 48 (ASCII of '0') to the character (charac).
 * If (state==0) store the value (val) at the position (pos) of the 
 * array (aSecret) and we will change the character read by a '*' 
 * (charac = '*') for which the secret combination we write is not seen.
 * If (state!=0) store the value (val) at the position (pos) of the 
 * array (aPlay)
 * Finally, we show the character (charac) on the screen at the position 
 * where is the cursor calling the printchP1_C function.
 * 
 * Global variables used:	
 * (charac)  : Character read from the keyboard.
 * (state)   : State of the game.
 * (aSecret) : Array where we store the secret code value of the character read.
 * (aPlay)   : Array where we store the tries value of the character read.
 * (pos)     : The place where we store the value read [0..4].
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'updateArrayP1' is defined.
 */
void updateArrayP1_C(){

   int val = (int)(charac-'0');
   if (state==0) {
      aSecret[pos]=val;
      charac='*';
   } else {
	  aPlay[pos]=val;
   }
   
   printchP1_C();
}


/**
 * Verify that the secret code (aSecret) does not have the value -3, 
 * (initial value), or repeated numbers.
 * For each element of the array (aSecret) check that there is no -3 and 
 * that it is not repeated in the rest of the array (from the next 
 * position to the current one until the end). 
 * To indicate that the secret code is not correct we set (secretError = 1).
 * If the secret code is correct, set (state = 1) to read tries.
 * If the secret code is incorrect, set (state = 2) to request it again.
 *  
 * Global variables used:
 * (aSecret) : Array where we store the secret code.
 * (state)   : State of the game.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'checkSecreP1' is defined. 
 */
void checkSecretP1_C() {
   int i,j;
   int secretError = 0;
     
   for (i=0;i<ARRAYDIM;i++) {
     if (aSecret[i]==-3) {
       secretError=1;
     }
     for (j=i+1;j<ARRAYDIM;j++) {
       if (aSecret[i]==aSecret[j]){
		 secretError=1;
	   }
     }
   }
   
   if (secretError==1) state = 2; 
   else state = 1; 

}


/**
 * Show a combination of the game.
 * If (state! = 1) shows the secret code (aSecret) in row 3 (row = 3), 
 * if not, it shows the try (aPlay) in the row 
 * (row = 9+ (ARRAYDIM-tries) * 2), from column 8 (col = 8).
 * For each position of the array:
 * Place the cursor calling the gotoxyP1_C function.
 * If (state! = 1) get a value from the secret code (aSecret), 
 * if not, get a value from the try (aPlay), add '0' to the value gotten
 * from the array to convert it to character and show it calling 
 * the printchP1_C function.
 * Increase the column 2 by 2.
 * 
 * Global variables used:
 * (state)   : State of the game.
 * (row)     : Row of the screen where the cursor is placed.
 * (col)     : Column of the screen where the cursor is placed.
 * (tries)   : Remaining tries.
 * (aSecret) : Array where we store the secret code.
 * (aPlay)   : Array where we store the tries.
 * (charac)  : Character to show.
 *  
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'printSecretPlayP1' is defined.  
 */
void printSecretPlayP1_C() {
	
   int i;
   
   if (state!=1) {
      row = 3;
   } else {
      row = 9+(ARRAYDIM-tries)*2;
   }
   col = 8;
   for (i=0; i<ARRAYDIM; i++){
     gotoxyP1_C();
     if(state!=1) {
		 charac = aSecret[i]+'0';
     } else {
		 charac = aPlay[i]+'0';
     }
     printchP1_C();
     col = col + 2;     
   } 
   
}


/**
 * Count hits in place of the try (aPlay) with respect to 
 * the secret code (aSecret).
 * Compare each element of the secret code (aSecret) with the element
 * in the same position of the try (aPlay).
 * If an element of the secret combination (aSecret[i]) is equal to 
 * the element of the same position of the try (aPlay [i]): it will be
 * a hit in place 'X' and the hits in place must be increased (hX ++).
 * If all positions in the secret code (aSecret) and the try (aPlay) 
 * are equals (hX=ARRAYDIM), we have won and the game status must be 
 * modified to indicate it (state=3).
 * Show the hits in place in the game board
 * calling the printHitsP1_C function.
 * 
 * Global variables used:	
 * (aSecret) : Array where we store the secret code.
 * (aPlay)   : Array where we store the tries.
 * (state)   : State of the game.
 * (tries)   : Remaining tries.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'checkPlayP1' is defined.
 */
void checkPlayP1_C(){

   int i;
   hX = 0;
   for (i=0;i<ARRAYDIM;i++) {
	 if (aSecret[i]==aPlay[i]) {
       hX++;
     } 
   }
    
   if (hX == ARRAYDIM ) {
     state = 3;
   } 
   
   printHitsP1_C();
   
}


/**
 * Show the hits in place.
 * Place the cursor in the row (row=9+(ARRAYDIM-tr)*2) and column (col=22) 
 * (right side of the board) to show the hits on the game board.
 * Show as many 'X' as there are hits in place (hX).
 * To show the hits, position the cursor by calling the gotoxyP1_C 
 * function and show the characters by calling the printchP1_C function. 
 * Each time a hit is shown, the column must be increased by 2.
 * NOTE: (hX must always be smaller or equal than ARRAYDIM).
 * 
 * Global variables used:	
 * (row)    : Row of the screen where the cursor is placed.
 * (col)    : Column of the screen where the cursor is placed.
 * (tries)  : Remaining tries.
 * (charac) : Character to show.
 * (hX)     : Hits in place.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'printHitsP1' is defined.
 */ 
void printHitsP1_C() {
   int i;
   row = 9 + (ARRAYDIM-tries)*2;
   col = 22;
   charac = 'X';
   for(i=hX;i>0;i--) {
     gotoxyP1_C();
     printchP1_C();
     col = col + 2;
   }
   
}



/**
 * Show a message at the bottom right of the game board according to 
 * the value of the variable (status). 
 * (state) 0: We are typing the secret code.
 *         1: We are typing a tray.
 *         2: The secret code has the initial values or repeted values.
 *         3: Won, try = secret code.
 *         4: The tries have run out.
 *         5: Press ESC to exit
 * Is expected to press a key to continue. 
 * Show a message below on the  game board to indicate this, 
 * and pressing a key, it is deleted.
 * 
 * Global variables used:	
 * (row)   : Row of the screen where the cursor is placed.
 * (col)   : Column of the screen where the cursor is placed.
 * (state) : State of the game.
 * 
 * This function is called from C and from assembler code.
 * An equivalent assembly language subroutine is not defined.
 */
void printMessageP1_C(){

   row = 20;
   col = 11;
   gotoxyP1_C();
   switch(state){
     break;
     case 0: 
       printf("Write the Secret Code");
     break;
     case 1:
       printf(" Write a combination ");
     break;
     case 2:
       printf("Secret Code ERROR!!! ");
     break;
     case 3:
       printf("YOU WIN: CODE BROKEN!");
     break;
     case 4:
       printf("GAME OVER: No tries! ");
     break;
     case 5:
       printf(" EXIT: (ESC) PRESSED ");
     break;
   }
   row = 21;
   col = 11;
   gotoxyP1_C(); 
   printf("    Press any key ");
   getchP1_C();	  
   row = 21;
   col = 11;
   gotoxyP1_C();  
   printf("                  ");
   
}


/**
 * Main game function
 * Read the secret code and verify that it is correct.
 * Then a try is read, compare the try with 
 * the secret code to check the hits in place.
 * Repeat the process until the secret code is guessed or 
 * while there aren't tries left. If 'ESC' key is pressed while reading
 * the secret code or a try, exit.
 * 
 * Pseudo-code:
 * The player has 5 tries to guess the secret code, the initial state 
 * of the game is 0 and the cursor is set to position 0.
 * Show the game board by calling the printBoardP1_C function.
 * Show a message to indicate that the secret code must be typed 
 * by calling the printMessageP1_C function.
 * While (state == 0) read the secret code or (state == 2) read
 * the secret code because it wasn't correct:
 * - Set the initial state of the game to 0 (state = 0).
 *   While not pressing [ESC] or [ENTER]:
 *   - Place the cursor on the game board calling the posCurBoardP1_C function.
 *   - Read a key calling the getchP1_C function.
 *   - If a 'j' (left) or a 'k' (right) has been read, move the cursor 
 *     by the 5 positions of the combination, updating the index of 
 *     the array (pos +/- 1) calling the  updatePosP1_C function.
 *     (can't leave the area where we are typing (5 positions)).
 *   - If a valid character is read ['0' - '9'] we store it in the 
 *     array (aSecret), if (status == 0) we will change the character 
 *     read to a '*' so that the secret code we type can't be seen 
 *     and show this character on the screen at the position where 
 *     the cursor is calling the updateArrayP1_C function.
 *   - If ESC(27) is read, set (state = 5) to exit.
 * 
 *   If [ESC] has not been pressed (state! = 5) call the checkSecretP1_C 
 *   function to check if the secret code has a -3 or has repeated 
 *   numbers and display a message calling the printMessageP1_C function
 *   indicating that the tries can now be typed (state = 1) if the secret 
 *   code is correct or that the secret code is incorrect (state = 2).
 * 
 *   While (state == 1) we are typing tries:
 *   - Initialize the cursor position to 0 (pos = 0).
 *   - Show the remaining tries (tries) to guess the secret code, 
 *     place the cursor in row 21, column 5 calling the gotoxyP1_C 
 *     function and show the character associated with the value of the 
 *     variable (tries) adding '0' and calling the printchP1_C function.
 *   - Show the try we have in the array (aPlay), initially it will be 
 *     ("00000") and can be modified.
 * 
 *     While [ESC] or [ENTER] aren't pressed:
 *     - Place the cursor on the game board by calling the 
 *       posCurBoardP1_C function.
 *     - Read a key calling the getchP1_C function.
 *     - If a 'j' (left) or a 'k' (right) has been read, move the cursor 
 *       by the 5 positions of the combination, updating the index of 
 *       the array (pos +/- 1) calling the  updatePosP1_C function.
 *       (can't leave the area where we are typing (5 positions)).
 *     - If a valid character is read ['0' - '9'] we store it in the 
 *       array (aPlay) and show the character on the screen at 
 *       the position where the cursor is calling 
 *       the updateArrayP1_C function.
 *     - If an ESC(27) has been read, set (state = 5) to exit.
 * 
 *    If [ESC] is not pressed (state! = 5) call the chekPlaysP1_C 
 *    function to count the hits in place of the try (aPlay) 
 *    with respect to the secret code (aSecret), 
 *    if the try is equal, position by position, to the secret code, 
 *    we won the game (state = 3).
 *    We decrease the tries (tries), and if there are no tries left 
 *    (tries == 0) and we didn't guess the secret code (state == 1), 
 *    we lost the game (state = 4).
 * 
 * Finally, show the secret code calling the printSecretPlayP1_C 
 * function. In addition, show the remaining tries (tries) to guess the 
 * secret code, place the cursor in row 21, column 5 by calling the 
 * gotoxyP1_C function and show the character associated with the 
 * value of the variable (tries) by adding '0' and calling the 
 * printchP1_C function, finally show the message indicating the 
 * reason calling the printMessageP1_C function.
 * Game over.
 * 
 * Global variables used:	
 * (state)  : State of the game.
 * (tries)  : Remaining tries.
 * (charac) : Character read from the keyboard and to show.
 * (pos)    : The place where the cursor is.
 * (row)    : Row of the screen where the cursor is placed.
 * (col)    : Column of the screen where the cursor is placed.
 * 
 * This function is not called from assembly code.
 * An equivalent assembly language subroutine 'playP1' is defined. 
 */
void playP1_C() {
   
   state = 0;
   tries = 5;
   pos=0;
   
   printBoardP1_C();
   printMessageP1_C();

   while (state == 0 || state == 2) {
	  state=0;
      do {
         posCurBoardP1_C();
	     getchP1_C();
         if ((charac=='j') || (charac=='k')){             
            updatePosP1_C();
         }
         if (charac>='0' && charac<='9'){   
            updateArrayP1_C();
         }
         if (charac == 27) {
           state = 5;    
         }
      } while ((charac!=10) && (charac!=27)); 
      if (state!=5) {
	     checkSecretP1_C();
         printMessageP1_C();
      }
   }
   
   while (state==1) {
	 pos = 0;
	 row=21;
	 col=5;
	 gotoxyP1_C();
	 charac=tries + '0';
     printchP1_C();
	 printSecretPlayP1_C();
	 do {
         posCurBoardP1_C();
	     getchP1_C();
         if ((charac=='j') || (charac=='k')){             
            updatePosP1_C();
         }
         if (charac>='0' && charac<='9'){   
            updateArrayP1_C();
         }
         if (charac == 27) {
           state = 5;    
         }
      } while ((charac!=10) && (charac!=27)); 
      if (state!=5) {
	     checkPlayP1_C();
	     tries--;
	     if (tries == 0 && state == 1) {
            state = 4;   
         }
      }
   }
   row=21;
   col=5;
   gotoxyP1_C();
   charac=tries + '0';
   printchP1_C();
   printSecretPlayP1_C();
   printMessageP1_C();
   
}


/**
 * Main Program
 * 
 * ATTENTION: In each option an assembly subroutine is called.
 * Below them there is a line comment with the equivalent C function 
 * that we give you done in case you want to see how it works.
 *  */
void main(void){   
   int i;
   int op=' ';      

   while (op!='0') {
     printMenuP1_C();	      //Show menu and return option.
     op = charac;
     switch(op){
       case '0':
         row=23;
         col=1;
         gotoxyP1_C(); 
         break;
       case '1':	          //Place the cursor on the game board.
         state=1;
         tries=5;
         pos = 0;		
         printBoardP1_C();
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");   
         //=======================================================
         posCurBoardP1();
         ///posCurBoardP1_C();
         //=======================================================
         getchP1_C();
         break;
       case '2':	          //Update cursor position.
         state=1;
         tries=5;
	     pos = 2;
         printBoardP1_C();
         row=21;
         col=11;  
         gotoxyP1_C();
         printf(" Press 'j' or 'k' ");
         posCurBoardP1_C();
         getchP1_C();
         if (charac=='j' || charac=='k') {
         //=======================================================
         updatePosP1();
         ///updatePosP1_C();	    
         //=======================================================
         }
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         posCurBoardP1_C();
         getchP1_C();
         break;
       case '3': 	          //Update array and show it on the screen.
         state=1;
         tries=5;
         pos=0;		  
         printBoardP1_C();
         printSecretPlayP1_C();
         row=21;
         col=11;
         gotoxyP1_C();
         printf(" Press (0-9) value ");
         posCurBoardP1_C();
         getchP1_C();
         if (charac>='0' && charac<='9'){       
         //=======================================================
         updateArrayP1();
         ///updateArrayP1_C();
         //=======================================================
         }
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         getchP1_C();
         break;
       case '4': 	          //Check the secret code.
         state=0;
         tries=5;
         pos=0;	
         printBoardP1_C();
         int secret1[ARRAYDIM] = {1,2,-3,4,1}; //Secret code
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret1[i];
         }  
         //=======================================================
         checkSecretP1();
         ///checkSecretP1_C();
         //=======================================================
         printSecretPlayP1_C();		
         printMessageP1_C();
         break;
       case '5': 	          //Show a combination of the game.
         state=1;
         tries=5;
         pos=0;
         printBoardP1_C();
         //=======================================================
         printSecretPlayP1();
         ///printSecretPlayP1_C();		
         //=======================================================
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         getchP1_C();
         break;
       case '6': 	          //Show hits.
         state=1;
         tries=5;
         pos=0;
         printBoardP1_C();
         hX = 4;
         //=======================================================
         printHitsP1();
         ///printHitsP1_C();
         //=======================================================
         row=21;
         col=11;
         gotoxyP1_C();
         printf("   Press any key  ");
         getchP1_C();
         break;
       case '7': 	          //Count hits in place and hits out of place.
         state=0;
         tries=5;
         pos=0;
         printBoardP1_C();
         int secret2[ARRAYDIM] = {1,2,3,4,0}; //Combinació secreta
         int play2[ARRAYDIM] = {1,4,3,0,5};   //Jugada
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret2[i];
           aPlay[i]=play2[i];
         } 
         printSecretPlayP1_C();
         state=1;
         printSecretPlayP1_C();	
         //=======================================================
         checkPlayP1();
         ///checkPlayP1_C();
         //=======================================================
         printMessageP1_C();
         break;
       case '8': 	          //Complete assembly language game..
         i=0;
         int secret0[ARRAYDIM] = {-3,-3,-3,-3,-3};//Secret code
         int play0[ARRAYDIM] = {0,0,0,0,0};       //Initial try
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret0[i];
           aPlay[i]=play0[i];
         } 
         //=======================================================
         playP1();
         //=======================================================
         break;
       case '9': 	           //Complete C language game.
         i=0;
         int secret[ARRAYDIM] = {-3,-3,-3,-3,-3}; //Secret code
         int play[ARRAYDIM] = {0,0,0,0,0};        //Initial try
         for (i=0;i<ARRAYDIM;i++) {
           aSecret[i]=secret[i];
           aPlay[i]=play[i];
         } 
         //=======================================================
         playP1_C();
         //=======================================================
         break;
     }
   }

}
