func doSomething(x: Int) -> () {
  if x > 0 {
    let y = x + 3
    println("X is greater than 0")
    println(y)
    return
  } else {
    println("X is 0 or less")
    return
  }
}

doSomething(3)
