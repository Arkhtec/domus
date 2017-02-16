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
    
    var div = document.getElementById("divPrincipal")
    var table = div.getElementsByTagName("div")[0].getElementsByTagName("table")[0]
    
   var  ttl;
   var valores = Array()

   for ( var i = 0; i < table.rows.length; i++ ) {
       var row = table.rows.item(i);
       var unidade = row.cells.item(0).innerText
       var morador = row.cells.item(1).innerText
       var calculo = row.cells.item(2).innerText
       var mes = row.cells.item(3).innerText
       var vencimento = row.cells.item(4).innerText
       var novoVencimento = row.cells.item(5).innerText
       var cod = row.cells.item(7).innerText
       var b = Boleto.boletoWithUnidadeNomeCalculoMesVencimento(unidade, morador, calculo, mes, vencimento)
       valores.push(b)
   }

    return valores
};

var toEmpresa = function() {
    return {"empresa": document.getElementById("lblEmpresa").innerText};
};
