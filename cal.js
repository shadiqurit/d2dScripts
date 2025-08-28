var tp   = ($v(tp)   == null || $v(tp)   === 0) ? 1 : $v(tp);
var exp  = ($v(exp)  == null || $v(exp)  === 0) ? 1 : $v(exp);
var tz   = ($v(tz)   == null || $v(tz)   === 0) ? 1 : $v(tz);
var zqty = ($v(zqty) == null || $v(zqty) === 0) ? 1 : $v(zqty);

Math.round(tp * exp * tz * zqty);
