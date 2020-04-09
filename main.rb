require 'fox16'

include Fox

NUMEROS = (1..9).to_a
MINUSCULAS = ("a".."z").to_a
MAYUSCULAS = ("A".."Z").to_a
TODO = (33..126).map{|x| x.chr}

class Ventana < FXMainWindow
    def initialize programa
        super(programa, "Generador de contraseñas", width: 400, height: 200)
    end
    def interfaz
        superior = FXHorizontalFrame.new self
        texto = FXLabel.new(superior, "Numero de caractéres:")
        caja = FXTextField.new(superior, 5)
        medio = FXHorizontalFrame.new self
        check = FXCheckButton.new(medio, "Incluir caractéres especiales")
        inferior = FXVerticalFrame.new(self, opts: LAYOUT_FILL)
        resultado = FXText.new(inferior, opts: LAYOUT_FILL | TEXT_READONLY | TEXT_WORDWRAP)
        botones = FXHorizontalFrame.new inferior
        boton_generar = FXButton.new(botones, "Generar")
        boton_copiar = FXButton.new(botones, "Copiar")
        #Acciones de los elementos
        boton_generar.connect SEL_COMMAND do
            if check.check
                @tipo = TODO
            else
                @tipo = NUMEROS + MINUSCULAS + MAYUSCULAS
            end
            resultado.removeText(0, resultado.length)
            resultado.appendText(generar(caja.text.to_i.abs, @tipo))
        end
        boton_copiar.connect SEL_COMMAND do
            acquireClipboard([FXWindow.stringType])
        end
        self.connect SEL_CLIPBOARD_REQUEST do
            setDNDData(FROM_CLIPBOARD, FXWindow.stringType, Fox.fxencodeStringData(resultado.text))
        end
    end
    def generar(longitud, tipo)
        (1..longitud).map do
            tipo.sample
        end.join
    end
end

FXApp.new do |programa|
    vista = Ventana.new programa
    vista.interfaz
    programa.create
    vista.show PLACEMENT_SCREEN
    programa.run
end
