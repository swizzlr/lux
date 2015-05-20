func fib(num: Int) -> Int{
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    if(num == 0){
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));        return 0;
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    }
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    if(num == 1){
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));        return 1;
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    }
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    return fib(num - 1) + fib(num - 2);
}
