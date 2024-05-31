/** First Wollok example */
object wollok {
	method howAreYou() {
		return 'I am Wolloktastic!'
	}
}

class Persona{
	var temperatura = 36
	var celulas
	const property enfermedades = []
	
	method temperatura() = temperatura
	
	method celulasTotales() = celulas
	
	method entroEnComa() = temperatura > 45 or celulas < 1000000
	
	method contraer(enfermedad){
		enfermedades.add(enfermedad)
	}
	
	method aumentarTemperatura(grados){
		temperatura += grados
	}
	
	method destruirCelulas(cantidad){
		celulas -= cantidad
	}
	
	method diaSiguiente(){
		enfermedades.forEach({
			e => e.efecto(self)
		})
	}
	
	method cantidadDeCelulasAmenazadas(){
		return enfermedades.sum({ e => e.celulasAmenazadas()})
	}
	
	method enfermedadMasPeligrosa(){
		return enfermedades.max({ e => e.celulasAmenazadas() })
	}
	
	method estaCurado() = self.cantidadDeCelulasAmenazadas() == 0 //otra opción seria -> self.enfermedades().isEmpty()
	
	method morir(){
		temperatura = 0
	}
	
}

class Medico inherits Persona{
	var dosis
	
	method dosis() = dosis
	
	method atender(persona){
		persona.enfermedades().forEach({ e =>  
			e.atenuar(self.dosis()*15)
			if (e.celulasAmenazadas() == 0) persona.enfermedades().remove(e)
		})
	}
}

//NO Supe resolver esta parte de que un jefe de departamento manda a otro, el enunciado está confuso. Falta información?
class JefeDepto inherits Medico{
	const property medicosDelDepto = []
	
	override method atender(persona){
		medicosDelDepto.first().atender(persona)
	}
}

class Enfermedad{
	var celulasAmenazadas
	
	method celulasAmenazadas() = celulasAmenazadas
	
	method atenuar(cantidad){
		celulasAmenazadas = 0.max(celulasAmenazadas-cantidad)
	}
	
}

class Infecciosa inherits Enfermedad{
	//Malaria u Otitis
	var increaseTemp = celulasAmenazadas/1000
	
	method esAgresiva(unaPersona) =  celulasAmenazadas >= unaPersona.celulasTotales()
	
	method reproducirse(){
		celulasAmenazadas += celulasAmenazadas
	}
	
	method efecto(enPersona){
		enPersona.aumentarTemperatura(increaseTemp)
	}
	
}

class Autoinmune inherits Enfermedad{
	//Lupus
	var dias = 0
	
	method esAgresiva() = dias >= 30
	
	method efecto(enPersona){
		enPersona.destruirCelulas(celulasAmenazadas)
		dias += 1
	}
}

class Muerte inherits Enfermedad{
	
	method esAgresiva() = true
	
	method efecto(enPersona){
		enPersona.morir()
	}
}



