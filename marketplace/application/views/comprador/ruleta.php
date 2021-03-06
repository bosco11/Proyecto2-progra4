<?php

if ($message_display != null) {
    if (isset($message_display)) {

        echo "<div class='alert alert-success alert-dismissible fade show' role='alert'style='font-size: 20px;'>"
            . $message_display .
            "<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button></div>";
    }
}
if ($error_message != null) {
    if (isset($error_message)) {

        echo "<div class='alert alert-danger alert-dismissible fade show' role='alert'style='font-size: 20px;'>"
            . $error_message .
            "<button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button></div>";
    }
}

?>
<div id="panel_app">
    <div class="box-header">
        <nav class="navbar navbar-dark bg-dark justify-content-between">
            <!-- form para regresar de vista -->
            <div class="container-fluid">
                <?php if ($seccion == TRUE) { ?>
                    <?php
                    if ($this->session->userdata['logged_in']['tipo'] == 'Tienda') { ?>
                        <?php echo form_open('tienda/tiendaHome'); ?>
                        <button type="submit" name="btn_return" id="btn_return" class="boton" title="Regresar">←<i class="fas fa-arrow-left"></i></button>
                        <?php echo form_close(); ?>
                    <?php  } else { ?>
                        <?php echo form_open('comprador/compradorHome'); ?>
                        <button type="submit" name="btn_return" id="btn_return" class="boton" title="Regresar"><i class="fas fa-arrow-left"></i></button>
                        <?php echo form_close(); ?>
                    <?php } ?>
                <?php } else { ?>
                    <?php echo form_open('comprador/compradorHome'); ?>
                    <button type="submit" name="btn_return" id="btn_return" class="boton" title="Regresar"><i class="fas fa-arrow-left"></i></button>
                    <?php echo form_close(); ?>
                <?php } ?>
                <?php
                $fecha = date("Y-m-d");
                // Se validan los giros que un usuario ha realizado
                if ($user['fecha_giros'] < $fecha) {
                    $result = 3;
                } else {
                    if ($user['fecha_giros'] <= $fecha) {
                        $total = 3;
                        $cantidad = $user['cantidad_giros'];
                        $result = $total - $cantidad;
                    }
                } //se habilita el boton de girar la ruleta si posee los giros suficientes
                if (sizeof($metodos) > 0 && $user['cantidad_giros'] < 3) { ?>
                    <h3>Cantidad de giros restantes: <?php echo $result ?></h3>
                    <button type="button" style="float:left; margin-left: 30px;" value="spin" id='spin' class="btn btn-primary">Girar la ruleta</button>

                <?php } else { ?>
                    <h3>Cantidad de giros restantes: <?php echo $result ?></h3>
                    <button type="button" style="float:left; margin-left: 30px;" value="spin" id='spin' class="btn btn-primary" disabled>Girar la ruleta</button>

                <?php } ?>
            </div>
        </nav>
    </div>
    <br>
    <!-- form donde se pinta la ruleta -->
    <div style="text-align: center;">
        <div id="main_panel" ">
            <div style="position: relative; right: 70px;"><h2  class="box-title">Ruleta de la suerte</h2></div>
            
            <canvas style="text-align: center;" id="canvas" width="600" height="600"></canvas>
        </div>
    </div>
    <br>
    <!-- showmodal para reclamar el premio -->
    <div class="modal fade" data-bs-backdrop="static" data-bs-keyboard="false" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <?php echo form_open('comprador/guardarPremio/' . $this->session->userdata['logged_in']['users_id']); ?>
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content" style="color: black;">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Felicidades has sido premiado</h5>

                </div>
                <div class="modal-body" style="color: black;">
                    <h3> Descripcion del premio:</h3>
                    <h2 id="nota"></h2>
                    <div id="pagos">
                        <label for="">Seleccione un metodo de pago al cual desea acreditar su premio</label>
                        <select name="cmb_tarjetas" id="cmb_tarjetas" class="form-select form-select-sm me-2" aria-label=".form-select-sm example">
                            <?php if (!empty($metodos)) { ?>
                                <?php foreach ($metodos as $met) { ?>
                                    <option value="<?php echo $met['id_formas_pago'] ?>">Numero Tarjeta:<?php echo $met['numero_tarjeta'] ?> - Saldo:<?php echo $met['saldo'] ?></option>
                                <?php } ?>
                            <?php } ?>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="hidden" value="" id="premio" name="premio">                 
                    <button type="submit" class="btn btn-primary">Aceptar</button>
                </div>
            </div>
        </div>
        <?php echo form_close(); ?>
    </div>

</div>
<script>
    // se declara el array de premios
    var options = ["$50", "Envío", "%10", "Nada", "$50", "Envío", "%10", "Nada", "$50", "Envío", "%10", "Nada", "$50", "Envío", "%10", "Nada", "$50", "Envío", "%10", "Nada"];

    var startAngle = 0;
    var arc = Math.PI / (options.length / 2);//operacion matematica para calcular el arco
    var spinTimeout = null;

    var spinArcStart = 10;
    var spinTime = 0;
    var spinTimeTotal = 0;

    var ctx;

    document.getElementById("spin").addEventListener("click", spin);
    // obtener los colores en codigo hexadecimal
    function byte2Hex(n) {
        var nybHexString = "0123456789ABCDEF";
        return String(nybHexString.substr((n >> 4) & 0x0F, 1)) + nybHexString.substr(n & 0x0F, 1);
    }

    function RGB2Color(r, g, b) {
        return '#' + byte2Hex(r) + byte2Hex(g) + byte2Hex(b);
    }
    // obtener los colores 
    function getColor(item, maxitem) {
        var phase = 0;
        var center = 128;
        var width = 127;
        var frequency = Math.PI * 2 / maxitem;

        red = Math.sin(frequency * item + 2 + phase) * width + center;
        green = Math.sin(frequency * item + 0 + phase) * width + center;
        blue = Math.sin(frequency * item + 4 + phase) * width + center;

        return RGB2Color(red, green, blue);//devuelve los colores
    }
    // Funcion para dibujar la ruleta con los colores
    function drawRouletteWheel() {
        var canvas = document.getElementById("canvas");
        if (canvas.getContext) {
            var outsideRadius = 200;
            var textRadius = 160;
            var insideRadius = 125;

            ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, 500, 500);

            ctx.strokeStyle = "black";
            ctx.lineWidth = 4;

            ctx.font = 'bold 12px Helvetica, Arial';
            // Se dibuja cada segmento de la ruleta
            for (var i = 0; i < options.length; i++) {
                var angle = startAngle + i * arc;
            
                ctx.fillStyle = getColor(i, options.length);

                ctx.beginPath();
                ctx.arc(250, 250, outsideRadius, angle, angle + arc, false);
                ctx.arc(250, 250, insideRadius, angle + arc, angle, true);
                ctx.stroke();
                ctx.fill();

                ctx.save();
                ctx.shadowOffsetX = -1;
                ctx.shadowOffsetY = -1;
                ctx.shadowBlur = 0;
                ctx.shadowColor = "rgb(220,220,220)";
                ctx.fillStyle = "black";
                ctx.translate(250 + Math.cos(angle + arc / 2) * textRadius,
                    250 + Math.sin(angle + arc / 2) * textRadius);
                ctx.rotate(angle + arc / 2 + Math.PI / 2);
                var text = options[i];
                ctx.fillText(text, -ctx.measureText(text).width / 2, 0);
                ctx.restore();
            }

            //Dibuja la flecha
            ctx.fillStyle = "white";
            ctx.beginPath();
            ctx.moveTo(250 - 4, 250 - (outsideRadius + 5));
            ctx.lineTo(250 + 4, 250 - (outsideRadius + 5));
            ctx.lineTo(250 + 4, 250 - (outsideRadius - 5));
            ctx.lineTo(250 + 9, 250 - (outsideRadius - 5));
            ctx.lineTo(250 + 0, 250 - (outsideRadius - 13));
            ctx.lineTo(250 - 9, 250 - (outsideRadius - 5));
            ctx.lineTo(250 - 4, 250 - (outsideRadius - 5));
            ctx.lineTo(250 - 4, 250 - (outsideRadius + 5));
            ctx.fill();
        }
    }
    // Funcion para iniciar el giro de la ruleta
    function spin() {
        document.getElementById('spin').disabled = "true";
        spinAngleStart = Math.random() * 10 + 10;
        spinTime = 0;
        spinTimeTotal = Math.random() * 3 + 16 * 1000;
        rotateWheel();
    }
    // Funcion que gira la ruleta 
    function rotateWheel() {
        spinTime += 30;
        if (spinTime >= spinTimeTotal) {
            stopRotateWheel();
            return;
        }
        var spinAngle = spinAngleStart - easeOut(spinTime, 0, spinAngleStart, spinTimeTotal);
        startAngle += (spinAngle * Math.PI / 180);
        drawRouletteWheel();
        spinTimeout = setTimeout('rotateWheel()', 30);
    }
    // Funcion que detiene el giro de la ruleta
    function stopRotateWheel() {
        clearTimeout(spinTimeout);
        var degrees = startAngle * 180 / Math.PI + 90;
        var arcd = arc * 180 / Math.PI;
        var index = Math.floor((360 - degrees % 360) / arcd);
        ctx.save();
        ctx.font = 'bold 30px Helvetica, Arial';
        var text = options[index]
        ctx.fillText(text, 250 - ctx.measureText(text).width / 2, 250 + 10);
        ctx.restore();
        // Se obtiene el premio
        document.getElementById('nota').innerHTML = text;
        document.getElementById('premio').value = text;
        if (text == "$50") {
            $('#pagos').prop('disabled', false);
            document.getElementById('pagos').style.display = "block";

        } else {
            $('#cmb_tarjetas').prop('pagos', true);
            document.getElementById('pagos').style.display = "none";
        }
        $('#exampleModalCenter').modal('show');
    }
    // Funcion para poder girar la ruleta
    function easeOut(t, b, c, d) {
        var ts = (t /= d) * t;
        var tc = ts * t;
        return b + c * (tc + -3 * ts + 3 * t);
    }
    // Funcion para cerrar el showmodal
    function closeModal() {
        $('#exampleModalCenter').modal('hide');
        drawRouletteWheel();
    }
    
    drawRouletteWheel();
</script>