const locationWindow = document.getElementById("location");
const statusWindow = document.getElementById("status");
const speedometerWindow = document.getElementById("speedometer");

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
const voice = document.getElementById("voice")

const speed = document.getElementById("speed-svg");
const speedtextkm = document.getElementById("speedtextkm")
const speedtextmiles = document.getElementById("speedtextmiles")
const fuel = document.getElementById("fuel-svg");
const fuel_path = document.getElementById("fuel-path");
const fuel_icon = document.getElementById("fuel-icon");

const seatbelt = document.getElementById("seatbelt");
const engine = document.getElementById("engine");
const highbeams = document.getElementById("beam");

let left = 0

window.addEventListener('message', (event) => {
    if (event.data.component == "position") {
        if (event.data.visible == null) {
            left = 1
            locationWindow.style.opacity = 1
            arrow.style.rotate = -event.data.heading + "deg"

            direction.innerText = event.data.direction
            zipcode.innerText = event.data.postal
            distance.innerText = event.data.distance
            streetname.innerText = event.data.street
            zone.innerText = event.data.zone
        } else {
            left = 0
            locationWindow.style.opacity = 0
        }
    }

    if (event.data.component == "status") {
        if (event.data.visible == null) {
            statusWindow.style.opacity = 1
            if (event.data.hungerVisible) { foodcontainer.style.display = "block" } else { foodcontainer.style.display = "none" }
            if (event.data.thirstVisible) { thirstcontainer.style.display = "block" } else { thirstcontainer.style.display = "none" }
            if (event.data.voiceVisible) { voice.style.display = "block" } else { voice.style.display = "none" }

            if (event.data.voiceTalking == true) {
                if (voice.classList.contains("disabled")) {
                    voice.classList.remove("disabled")
                }
            } else {
                if (!voice.classList.contains("disabled")) {
                    voice.classList.add("disabled")
                }
            }

            voice.src = event.data.voiceType

            let health = Math.round((event.data.health * 100) / event.data.maxhealth)
            if (health > 100) { health = 100 }
            let armor = Math.round((event.data.armor * 100) / 100)
            if (armor > 0) {
                armorcontainer.style.display = "block"
            } else {
                armorcontainer.style.display = "none"
            }
            let thirst = Math.round((event.data.thirst * 100) / 100)
            let food = Math.round((event.data.hunger * 100) / 100)

            let oxygen = Math.round((event.data.oxygen * 100) / 40)

            if (event.data.framework == "qbcore" || event.data.framework == "esx") {
                oxygen = Math.round((event.data.oxygen * 100) / 10)
            }

            if (oxygen < 0) { oxygen = 0 }

            if (oxygen != 100) {
                oxygencontainer.style.display = "block"
            } else {
                oxygencontainer.style.display = "none"
            }

            healthtext.innerText = health + "%"
            healthbar.style.width = (health * 150) / 100 + "px"
            healthbar.style.setProperty('--size', 150 - ((health * 150) / 100) + "px");
            armortext.innerText = armor + "%"
            armorbar.style.width = (armor * 150) / 100 + "px"
            armorbar.style.setProperty('--size', 150 - ((armor * 150) / 100) + "px");

            thirsttext.innerText = thirst + "%"
            thirstbar.style.width = (thirst * 150) / 100 + "px"
            thirstbar.style.setProperty('--size', 150 - ((thirst * 150) / 100) + "px");

            foodtext.innerText = food + "%"
            foodbar.style.width = (food * 150) / 100 + "px"
            foodbar.style.setProperty('--size', 150 - ((food * 150) / 100) + "px");

            oxygentext.innerText = oxygen + "%"
            oxygenbar.style.width = (oxygen * 150) / 100 + "px"
            oxygenbar.style.setProperty('--size', 150 - ((oxygen * 150) / 100) + "px");
        } else {
            if (event.data.visible == true) {
                statusWindow.style.opacity = 1
            } else {
                statusWindow.style.opacity = 0
            }
        }
    }

    if (event.data.component == "speedometer") {
        if (event.data.visible == null) {
            if (event.data.seatbeltVisible) { seatbelt.style.display = "block" } else { seatbelt.style.display = "none" }
            if (event.data.fuelVisible) { speedometerWindow.style.marginLeft = '0px'; fuel.style.display = "block"; fuel_path.style.display = "block"; fuel_icon.style.display = "block"; } else { speedometerWindow.style.marginLeft = '10px'; fuel.style.display = "none"; fuel_path.style.display = "none"; fuel_icon.style.display = "none"; }
            speedometerWindow.style.opacity = 1
            let percent_speed = (event.data.speed * 100) / (event.data.maxspeed + 50)
            let percent_fuel = (event.data.fuel * 100) / (event.data.maxfuel)
            if (event.data.framework == "qbcore") {
                percent_fuel = event.data.fuel
            }
            setDashedGaugeValue(speed, percent_speed, 219.911485751);
            setDashedGaugeValue(fuel, percent_fuel, 87.9645943005);
            speedtextkm.innerText = Math.round(event.data.speed)
            speedtextmiles.innerText = Math.round(event.data.speed)

            if (event.data.iselectric == true) {
                fuel_icon.src = "battery.png"
            } else {
                fuel_icon.src = "gas.png"
            }

            if (event.data.useMiles == true) {
                speedtextkm.style.display = "none"
                speedtextmiles.style.display = "block"
            } else {
                speedtextkm.style.display = "block"
                speedtextmiles.style.display = "none"
            }

            if (event.data.hasmotor == true) {
                highbeams.style.display = "block"
                engine.style.display = "block"
                speedometerWindow.style.marginLeft = '0px'
                speedometerWindow.style.marginBottom = '0px'
            } else {
                highbeams.style.display = "none"
                engine.style.display = "none"
                seatbelt.style.display = "none"
                fuel.style.display = "none"
                fuel_path.style.display = "none"
                fuel_icon.style.display = "none"
                speedometerWindow.style.marginLeft = '10px'
                speedometerWindow.style.marginBottom = '-10px'
            }

            if (event.data.highbeams == 1) {
                if (highbeams.classList.contains("disabled")) {
                    highbeams.classList.remove("disabled")
                }
            } else {
                if (!highbeams.classList.contains("disabled")) {
                    highbeams.classList.add("disabled")
                }
            }

            if (event.data.engine == 1) {
                if (engine.classList.contains("disabled")) {
                    engine.classList.remove("disabled")
                }
            } else {
                if (!engine.classList.contains("disabled")) {
                    engine.classList.add("disabled")
                }
            }

            if (event.data.seatbelt == true) {
                if (seatbelt.classList.contains("disabled")) {
                    seatbelt.classList.remove("disabled")
                }
            } else {
                if (!seatbelt.classList.contains("disabled")) {
                    seatbelt.classList.add("disabled")
                }
            }
        } else {
            speedometerWindow.style.opacity = 0
        }
    }

    if (event.data.component == "configuration") {
        locationWindow.style.left = event.data.locationleft + "px"
        locationWindow.style.bottom = event.data.locationbottom + "px"
        statusWindow.style.right = event.data.statusright + "px"
        statusWindow.style.bottom = event.data.statusbottom + "px"
        speedometerWindow.style.bottom = event.data.speedometerbottom + "px"
    }
})

function setDashedGaugeValue(gaugeDOMElement, percentage, arcLength) {
    const emptyDashLength = 500;
    const filledArcLength = arcLength * (percentage / 100);
    gaugeDOMElement.style.strokeDasharray = `${filledArcLength} ${emptyDashLength}`;
    gaugeDOMElement.style.strokeDashoffset = filledArcLength;
}

setDashedGaugeValue(speed, 0, 219.911485751);
setDashedGaugeValue(fuel, 0, 87.9645943005);