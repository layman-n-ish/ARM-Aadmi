#include "stm32f4xx.h"
#include <string.h>

void printTable(const int choice)
{
	 char *str;
	 
	 if(choice==0){ str = "\nTruth Table of AND (input1, input2, input3, output):\n"; }
	 if(choice==1){ str = "\nTruth Table of OR (input1, input2, input3, output):\n"; }
	 if(choice==2){ str = "\nTruth Table of NAND (input1, input2, input3, output):\n"; }
	 if(choice==3){ str = "\nTruth Table of NOR (input1, input2, input3, output):\n"; }
	 if(choice==4){ str = "\nTruth Table of XOR (input1, input2, input3, output):\n"; }
	 if(choice==5){ str = "\nTruth Table of XNOR (input1, input2, input3, output)n"; }
	 if(choice==6){ str = "\nTruth Table of NOT (input, output):\n"; }
	
	 while(*str != '\0'){
      ITM_SendChar(*str);
      ++str;
   }
	 return;}

void printErrorMsg()
{
		char Msg[100];
		char *ptr;
		sprintf(Msg,"[Error] Please make a selection between 0-6...\n");
		ptr = Msg ;
		while(*ptr != '\0'){
				ITM_SendChar(*ptr);
				++ptr;
   }
}

void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}
void printMsg2p(const int a, const int b)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%x ", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 sprintf(Msg, "%x \n", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
}

void printMsg4p(const int a, const int b, const int c, const int d)
{
	 char Msg[100];
	 char *ptr;
	
	 sprintf(Msg, "%x ", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	
	 sprintf(Msg, "%x ", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 
	 sprintf(Msg, "%x ", c);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }

	 sprintf(Msg, "%x\n", d);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
	 }
}