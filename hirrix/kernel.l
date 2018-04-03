class kernel

var toPrint

cpp extern "C" void kernel_main(void* multiboot_structure, int magicNumber) {
cpp %ttoPrint = "Hello World!\nWelcome to HirrixOS coded only in Linit and Assembly"
cpp %tprintf();
cpp %twhile (1);
cpp }

func printf
	cpp %tstatic short* VideoMemory = (short*) 0xb8000;
	cpp %tstatic char x = 0, y = 0;
	cpp %tfor (int i = 0; toPrint[i] = '\0'; i++) {
	cpp %t%tswitch (toPrint[i]) {
	cpp %t%t%tcase '\n':
	cpp %t%t%t%ty++;
	cpp %t%t%t%tx = 0;
	cpp %t%t%t%tbreak;
	cpp %t%t%tdefault:
	cpp %t%t%t%tVideoMemory[80 * y + x] = (VideoMemory[80 * y + x] & 0xFF00) | toPrint[i];
	cpp %t%t%t%tx++;
	cpp %t%t%t%tbreak;
	cpp %t%t}
	cpp %t}
end
