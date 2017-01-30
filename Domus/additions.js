'use strict';

var toDictionaryDefault = function () {
    return {"strAdmin": document.getElementById("strAdmin").value, "acessoDireto": document.getElementById("acessoDireto").value, "id_usuario": document.getElementById("id_usuario").value};
};


var toUsuario = function () {
    return User.userWithNomeEmailBlocoAptoVencimento(document.getElementById("txtNome").value, document.getElementById("txtEmail").value,
                                  document.getElementById("txtBloco").value, document.getElementById("txtApto").value,
                                  document.getElementById("txtVcto").value);
};

var valores = function() {
    
//    var refTab=document.getElementById("ddReferences")
//    var refTab = document.getElementsByTagName("table")[2];
//    var  ttl;
//    // Loop through all rows and columns of the table and popup alert with the value
//    // /content of each cell.
//    var valores = []
//    for ( var i = 0; i<refTab.rows.length; i++ ) {
//        var row = refTab.rows.item(i);
//        for ( var j = 0; j<row.cells.length; j++ ) {
//            var col = row.cells.item(j);
////            alert(col.firstChild.innerText);
//            valores.push(col.firstChild.innerText);
//        } 
//    }
//    return valores;
    return "teste"
};

var toEmpresa = function() {
    return {"empresa": document.getElementById("lblEmpresa").innerText};
};
