macro incsrc(file)
    namespace <file>
        incsrc "../smas_pause_menu/<file>.asm"
    namespace off
endmacro

%incsrc(settings)
%incsrc(defines)
%incsrc(main)
%incsrc(nmi)
