use std::process::Command;

fn main() {
  match Command::new("systemctl").arg("restart").arg("rails.service").status() {
    Ok(status) => println!("Estado del reinicio de rails.service: {:?}", status),
    Err(e) => eprintln!("Error al reiniciar rails.service: {}", e),
  }
    
  match Command::new("service").arg("nginx").arg("restart").status() {
    Ok(status) => println!("Estado del reinicio de nginx: {:?}", status),
    Err(e) => eprintln!("Error al reiniciar nginx: {}", e),
  }
}
