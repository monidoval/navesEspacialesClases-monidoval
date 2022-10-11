class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var property combustible = 0
	
	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto) {0.max(velocidad - cuanto)}
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	
	method acercarseUnPocoAlSol(){
		direccion= -10.max(direccion + 1)
	}
	method alejarseUnPocoDelSol(){
		direccion = 10.min(direccion - 1)
	}
	method cargarCombustible(unaCantidad){ 
		combustible += unaCantidad
	}
	method descargarCombustible(unaCantidad){
		combustible = 0.max(combustible - unaCantidad)
	}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila(){return
		combustible >= 400 &&
		velocidad <= 12000
	}
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method escapar(){}
	method avisar(){}
	method estaDeRelajo(){return
		self.estaTranquila() && 
		self.tienePocaActividad()		
	}
	method tienePocaActividad(){return true}	
}


class NaveBaliza inherits NaveEspacial{
	var property colorBaliza = "verde"
	var cantidadDeCambios = 0
	
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza=colorNuevo
		cantidadDeCambios ++
	}	
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquila(){return
		super() && colorBaliza != "rojo"
	}
	override method escapar(){
		self.irHaciaElSol()
	}
	override method avisar(){
		self.cambiarColorDeBaliza("rojo")
	}
	override method tienePocaActividad(){return 
		cantidadDeCambios == 0
	}
}


class NaveDePasajeros inherits NaveEspacial{
	var property racionesDeComida = 0
	var property racionesDeBebida = 0
	var property cantidadDePasajeros = 0
	var racionesServidas = 0 
	
	
	method cargarComida(cantRaciones){
		racionesDeComida += cantRaciones		
	}
	method cargarBebida(cantRaciones){
		racionesDeBebida += cantRaciones		
	}
	method descargarComida(cantRaciones){
		racionesDeComida= 0.max(racionesDeComida - cantRaciones	)	
		racionesServidas += cantRaciones
	}
	method descargarBebida(cantRaciones){
		racionesDeBebida= 0.max(racionesDeBebida - cantRaciones	)		
	}
	override method prepararViaje(){
		super()
		self.cargarComida(cantidadDePasajeros * 4)
		self.cargarBebida(cantidadDePasajeros * 6)
		self.acercarseUnPocoAlSol()		
	}
	override method escapar(){
		velocidad = velocidad * 2
	}
	override method avisar(){
		self.descargarComida(cantidadDePasajeros)
		self.descargarBebida(cantidadDePasajeros * 2)
	}
	override method tienePocaActividad(){return 
		racionesServidas < 50
	}	
}


class NaveDeCombate inherits NaveEspacial{
	var estaVisible = true
	var tieneMisilesDesplegados = false
	const property mensajesEmitidos=[]
	
	method estaInvisible()= not estaVisible
	method ponerseVisible(){ estaVisible = true}
	method ponerseInvisible(){ estaVisible = false}
	method desplegarMisiles(){tieneMisilesDesplegados = true}
	method replegarMisiles(){tieneMisilesDesplegados = false}
	method misilesDesplegados()= tieneMisilesDesplegados
	method emitirMensaje(unMensaje){
		mensajesEmitidos.add(unMensaje)
	}
	method primerMensajeEmitido(){return
		mensajesEmitidos.first()
	}
	method ultimoMensajeEmitido(){return
		mensajesEmitidos.last()
	}
	method esEscueta(){return
		not mensajesEmitidos.any({m => m.length() >= 30})		
	}
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en mision")		
	}
	override method estaTranquila(){return
		super() && !self.misilesDesplegados()
	}
	override method escapar(){
		self.acercarseUnPocoAlSol()	
		self.acercarseUnPocoAlSol()		
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	override method tienePocaActividad(){return 
		self.esEscueta()
		}
}


class NaveHospital inherits NaveDePasajeros{
	var property quirofanosPreparados = false	
	
	override method estaTranquila(){return
		super() && !self.quirofanosPreparados()
	}
	override method recibirAmenaza(){
		super()
		self.quirofanosPreparados(true) 
	}	
}


class NaveDeCombateSigilosa inherits NaveDeCombate{
	
	override method estaTranquila(){return
		super() && !self.estaInvisible()
	}
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
		}
}
