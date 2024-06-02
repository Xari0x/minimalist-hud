const locationWindow = document.getElementById("location");
const statusWindow = document.getElementById("status");

const arrow = document.getElementById("arrow");
const direction = document.getElementById("direction");
const zipcode = document.getElementById("zipcode");
const distance = document.getElementById("distance");
const streetname = document.getElementById("streetname");
const zone = document.getElementById("zone");

const thirstcontainer = document.getElementById("thirstcontainer");
const foodcontainer = document.getElementById("foodcontainer");
const armorcontainer = document.getElementById("armorcontainer");
const oxygencontainer = document.getElementById("oxygencontainer");

const healthtext = document.getElementById("healthtext")
const armortext = document.getElementById("armortext")
const thirsttext = document.getElementById("thirsttext")
const foodtext = document.getElementById("foodtext")
const oxygentext = document.getElementById("oxygentext")
const healthbar = document.getElementById("health")
const armorbar = document.getElementById("armor")
const thirstbar = document.getElementById("thirst")
const foodbar = document.getElementById("food")
const oxygenbar = document.getElementById("oxygen")

window.addEventListener('message', (event) => {
    if(event.data.component == "position"){
        if(event.data.visible == null){
            locationWindow.style.opacity = 1
            arrow.style.rotate = -event.data.heading + "deg"

            direction.innerText = event.data.direction
            zipcode.innerText = event.data.postal
            distance.innerText = event.data.distance
            streetname.innerText = event.data.street
            zone.innerText = event.data.zone
        }else{
            locationWindow.style.opacity = 0
        }
    }

    if(event.data.component == "status"){
        if(event.data.visible == null){
            statusWindow.style.opacity = 1
            if(event.data.hungerVisible) { foodcontainer.style.display = "block" }else{ foodcontainer.style.display = "none" }
            if(event.data.thirstVisible) { thirstcontainer.style.display = "block" }else{ thirstcontainer.style.display = "none" }
            
            let health = Math.round((event.data.health * 100)/event.data.maxhealth)
            if(health > 100){health = 100}
            let armor = Math.round((event.data.armor * 100)/100)
            if(armor > 0){
                armorcontainer.style.display = "block"
            }else{
                armorcontainer.style.display = "none"
            }
            let thirst = Math.round((event.data.thirst * 100)/100)
            let food = Math.round((event.data.hunger * 100)/100)

            let oxygen = Math.round((event.data.oxygen * 100)/40)
            if(oxygen < 0){oxygen = 0}

            if(oxygen != 100){
                oxygencontainer.style.display = "block"
            }else{
                oxygencontainer.style.display = "none"
            }

            healthtext.innerText = health + "%"
            healthbar.style.width = (health*150)/100 + "px"
            healthbar.style.setProperty('--size', 150-((health*150)/100) + "px");
            armortext.innerText = armor + "%"
            armorbar.style.width = (armor*150)/100 + "px"
            armorbar.style.setProperty('--size', 150-((armor*150)/100) + "px");

            thirsttext.innerText = thirst + "%"
            thirstbar.style.width = (thirst*150)/100 + "px"
            thirstbar.style.setProperty('--size', 150-((thirst*150)/100) + "px");
            
            foodtext.innerText = food + "%"
            foodbar.style.width = (food*150)/100 + "px"
            foodbar.style.setProperty('--size', 150-((food*150)/100) + "px");

            oxygentext.innerText = oxygen + "%"
            oxygenbar.style.width = (oxygen*150)/100 + "px"
            oxygenbar.style.setProperty('--size', 150-((oxygen*150)/100) + "px");
        }else{
            statusWindow.style.opacity = 0
        }
    }
})