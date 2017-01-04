'use strict';

var toDictionaryDefault = function () {
    return {"strAdmin": document.getElementById("strAdmin").value, "acessoDireto": document.getElementById("acessoDireto").value, "id_usuario": document.getElementById("id_usuario").value};
};


var toUsuario = function () {
    return User.userWithNomeEmail(document.getElementById("txtNome").value, document.getElementById("txtEmail").value);
};
