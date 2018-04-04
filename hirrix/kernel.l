class kernel; Déclaration de la class 'kernel'

var VGA_WIDTH; Largeur de l'écran
var VGA_HEIGHT; Hauteur de l'écran

; Déclaration des variables de couleur VGA
var VGA_COLOR_BLACK; 0
var VGA_COLOR_BLUE; 1
var VGA_COLOR_GREEN; 2
var VGA_COLOR_CYAN; 3
var VGA_COLOR_RED; 4
var VGA_COLOR_MAGENTA; 5
var VGA_COLOR_BROWN; 6
var VGA_COLOR_LIGHT_GREY; 7
var VGA_COLOR_DARK_GREY; 8
var VGA_COLOR_LIGHT_BLUE; 9
var VGA_COLOR_LIGHT_GREEN; 10
var VGA_COLOR_LIGHT_CYAN; 11
var VGA_COLOR_LIGHT_RED; 12
var VGA_COLOR_LIGHT_MAGENTA; 13
var VGA_COLOR_LIGHT_BROWN; 14
var VGA_COLOR_WHITE; 15
; ==========================

; Arguments pour la méthode vga_entry_color
var fg_vga_entry_color_arg
var bg_vga_entry_color_arg
var vga_entry_color_return ; Égal au return 

func vga_entry_color
	cpp vga_entry_color_return = fg_vga_entry_color_arg | bg_vga_entry_color_arg << 4;
end
;=============================

; Méthode vga_entry C++
cpp short vga_entry(unsigned char uc, char color) {
cpp %treturn (short) uc | (short) color << 8;
cpp }

; Initialisation du terminal
var terminal_row
var terminal_column
var terminal_color
cpp short* terminal_buffer;

func terminal_init
	def terminal_row = 0 ; Reset le nombre de lignes
	def terminal_column = 0 ; Reset le nombre de colonnes
	
	def fg_vga_entry_color_arg = 7 ; Définit la valeur de l'argument fg de vga_entry_color()
	def bg_vga_entry_color_arg = 0 ; Définit la valeur de l'argument bg de vga_entry_color()
	cpp vga_entry_color();// égal à vga_entry_color(7, 0)
	
	def terminal_color = vga_entry_color_return ; Récupère le return de vga_entry_color
	
	cpp terminal_buffer = (short*) 0xb8000; // Définit l'adresse ou se situe les entrée VGA
	
	; Permet de supprimer tout ce qu'il y a écrit sur l'écran VGA
	cpp for (char y = 0; y < VGA_HEIGHT; y++) {
	cpp %tfor (char x = 0; x < VGA_WIDTH; x++) {
	cpp %t%tterminal_buffer[y * VGA_HEIGHT + x] = (terminal_buffer[y * VGA_HEIGHT + x] & 0xFF00) | vga_entry(' ', terminal_color);
	cpp %t}
	cpp }
end
;=====================================

; strlen -> <text>.length C++ Permet de récupérer la longueur d'un texte
cpp int strlen(char* str){
cpp %tint len = 0;
cpp %twhile(str[len])
cpp %t%tlen++;
cpp %treturn len;
cpp }

;=====================================

; Méthode terminal_putentryat -> Permet d'afficher une Lettre/Chiffre à un endroit précis de l'écran
var terminal_putentryat_arg_char ; Lettre à écrire
var terminal_putentryat_arg_color ; Couleur VGA de la lettre
var terminal_putentryat_x ; Position X
var terminal_putentryat_y ; Position Y
var terminal_putentryat_index ; Méthode pour récupérer une entrée dans le tableau terminal_buffer[]

func terminal_putentryat
	cpp terminal_putentryat_index = terminal_putentryat_y * VGA_HEIGHT + terminal_putentryat_x;
	cpp if (terminal_putentryat_arg_char == '\n') {
	cpp %tterminal_column = 0;
	cpp %tterminal_row++;
	cpp } else {
	cpp %tterminal_buffer[terminal_putentryat_index] = (terminal_buffer[terminal_putentryat_index] & 0xFF00) | vga_entry(terminal_putentryat_arg_char, terminal_putentryat_arg_color);
	cpp }
end
;=====================================

; Méthode terminal_putchar C++
cpp void terminal_putchar(char c) {
cpp %tterminal_putentryat_arg_char = c;
cpp %tterminal_putentryat_arg_color = terminal_color;
cpp %tterminal_putentryat_x = terminal_column;
cpp %tterminal_putentryat_y = terminal_row;
cpp %tterminal_putentryat();
cpp %tif (++terminal_column >= VGA_WIDTH) {
cpp %t%tterminal_column = 0;
cpp %t%tif (++terminal_row >= VGA_HEIGHT) {
cpp %t%t%tterminal_row = 0;
cpp %t%t}
cpp %t}
cpp }
;======================================

; Méthode terminal_write C++
cpp void terminal_write(char* c, int size) {
cpp %tfor (int index = 0; index < size; index++) {
cpp %t%tterminal_putchar(c[index]);
cpp %t}
cpp }

;======================================

; Méthode terminal_writestring
cpp void terminal_writestring(char* c) {
cpp %tterminal_write(c, strlen(c));
cpp}
;======================================

; Méthode kernel_main C++
cpp extern "C" void kernel_main(void* multiboot_structure, unsigned int /*magicNumber*/) {
cpp %tkernel_init();
cpp %tterminal_init();
cpp %tterminal_writestring("Hello World!\nWelcome to HirrixOS coded only in Linit");
cpp %twhile(1);
cpp }
;======================================

; Méthode callConstructors C++
cpp typedef void (*constructor)();
cpp extern "C" constructor start_ctors;
cpp extern "C" constructor end_ctors;
cpp extern "C" void callConstructors() {
cpp %tfor (constructor* i = &start_ctors; i != &end_ctors; i++)
cpp %t%t(*i)();
cpp }
; =====================================

; Initialisation du kernel
func kernel_init
	; Initialisation des arguments pour la méthode vga_entry_color
	def fg_vga_entry_color_arg = 15
	def bg_vga_entry_color_arg = 0
	def vga_entry_color_return = -1 ; Permet de créer un char et non un unsigned car vga_entry_color_return < 0
	;========================
	; Initialisation des couleurs VGA
	def VGA_COLOR_BLACK = 0
	def VGA_COLOR_BLUE = 1
	def VGA_COLOR_GREEN = 2
	def VGA_COLOR_CYAN = 3
	def VGA_COLOR_RED = 4
	def VGA_COLOR_MAGENTA = 5
	def VGA_COLOR_BROWN = 6
	def VGA_COLOR_LIGHT_GREY = 7
	def VGA_COLOR_DARK_GREY = 8
	def VGA_COLOR_LIGHT_BLUE = 9
	def VGA_COLOR_LIGHT_GREEN = 10
	def VGA_COLOR_LIGHT_CYAN = 11
	def VGA_COLOR_LIGHT_RED = 12
	def VGA_COLOR_LIGHT_MAGENTA = 13
	def VGA_COLOR_LIGHT_BROWN = 14
	def VGA_COLOR_WHITE = 15
	;==========================
	; Initialisation de la résolution d'écran VGA
	def VGA_WIDTH = 80
	def VGA_HEIGHT = 25
	;==========================
	; Initialisation des arguments pour terminal_putentryat
	def terminal_putentryat_arg_char = -1 ; valeur = -1 -> Permet de supprimer le unsigned
	def terminal_putentryat_arg_color = 0; Permet d'avoir un unsigned char
	def terminal_putentryat_index = -32769; -32769 -> Permet d'obtenir un entier int
	def terminal_putentryat_x = 0; Permet d'avoir un unsigned char
	def terminal_putentryat_y = 0; Permet d'avoir un unsigned char
	;==========================
	def terminal_color = 0; Permet d'avoir un unsigned char
	call terminal_init ; Initialisation du terminal
end
