;; contrato hello world en pact
;; guarda un nombre en una tabla y luego lo saluda

;; keyset del admin, se lee de los datos de la transaccion
(define-keyset "admin-keyset" (read-keyset "admin-keyset"))

(module hello-pact GOV
  "Contrato que guarda un nombre en una tabla y lo saluda"

  ;; gobernanza del modulo, solo el admin puede modificarlo
  (defcap GOV ()
    (enforce-keyset "admin-keyset"))

  ;; capability para poder guardar el nombre
  (defcap ADMIN ()
    (enforce-keyset "admin-keyset"))

  ;; esquema de la tabla, solo guardamos el nombre
  (defschema esquema-nombre
    nombre:string)

  (deftable tabla-nombres:{esquema-nombre})

  ;; guarda el nombre en la tabla (solo con la llave correcta)
  (defun guardar-nombre (nombre:string)
    "Guarda el nombre en la tabla"
    (with-capability (ADMIN)
      (write tabla-nombres "actual" {"nombre": nombre})))

  ;; lee el nombre guardado y lo saluda
  (defun saludar ()
    "Saluda al nombre guardado en la tabla"
    (with-read tabla-nombres "actual" {"nombre" := n}
      (format "Hola, {}!" [n])))
)

;; se crea la tabla despues de definir el modulo
(create-table tabla-nombres)