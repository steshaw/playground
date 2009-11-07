package controllers

import play._
import play.mvc._
import play.data.validation._

object Application extends Actions {

  def index = render()

  def hello = renderText("Hello Scala+Play!")

  def sayHello(@Required name:String) {
    if (Validation.hasErrors()) {
      flash.error("Oops, please enter your name!")
      index
    }
    if (name == null) {
      println("name is >>null<<")
    } else {
      println("Hello '" + name + "'")
    }
    render(name)
  }

}
