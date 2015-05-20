func doSomething(x: Int) -> () {
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));  if x > 0 {
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    let y = x + 3
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    println("X is greater than 0")
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    println(y)
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    return
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));  } else {
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    println("X is 0 or less")
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));    return
println(":co.swizzlr.lux:"+__FILE__+":co.swizzlr.lux:"+String(__LINE__));  }
}

doSomething(3)
