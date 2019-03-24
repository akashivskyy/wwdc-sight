// Main.xcplaygroundpage
// Copyright © 2019 Adrian Kashivskyy.

//: ## 👁 How do eyes work?
//:
//: Basically, when the light passes through eyes, it eventually hits two
//: types of photoreceptor cells at the back of the retina:
//:
//: ### Rods
//:
//: ![](rod.png)
//:
//: Rods allow to see in low light conditions but they're not very good at
//: distinguishing colors. The more rods there are, the better nocturnal vision
//: the eye has.
//:
//: ### Cones
//:
//: ![](cone.png)
//:
//: Cones are sensitive to a certain range of light wavelength. Based on
//: readings from different types of cones, the brain can combine them into a
//: color.
//:
//: Most humans have three types of cones:
//:
//: - **L**, sensitive to long wavelengths, e.g. red,
//: - **M**, sensitive to medium wavelengths, e.g. green,
//: - **S**, sensitive to short wavelengths, e.g. blue.
//:
//: As it turns out, human eyes are pretty boring when compared to other members
//: of the animal kingdom.
//:
//: Use the live view to compare how different animals see the world!

let human = Sight.nocturnal(
    icons: [
        "🧔", "👨‍🍳", "👨‍🎨",
        "🕵️‍♂️", "👨‍⚖️", "👨‍🔧",
        "👩", "👩‍🔬", "👩‍✈️",
        "👩‍💻", "🦸‍♀️", "👩‍🏫",
    ],
    name: "Human",
    dayEffect: .human(day: true),
    nightEffect: .human(day: false),
    magnetic: false
)

//: ## 🐶 Dogs
//:
//: **Dogs don't see in black-and-white.** Let's bust that myth once and for
//: all. Dogs are deuteranopists because their eyes are missing the L cones.
//: This means they only see the world in shades of blues, greens and yellows.
//: In addition, their vision is slightly more blurry than human.
//:
//: ![](spectrum-human.png)
//: ![](spectrum-dog.png)
//:
//: This is why dogs rely on other senses, such as smell, to navigate through
//: the world.
//:
//: Tap the **camera switch** button to see how a dog sees you!

let dog = Sight.nocturnal(
    icons: ["🐶"],
    name: "Dog",
    dayEffect: .dog(day: true),
    nightEffect: .dog(day: false),
    magnetic: false
)

//: ## 🐈 Cats
//:
//: Cats have a very similar color perception as dogs, except slightly less
//: blurry. However, cats have way more rods in their eyes than humans, allowing
//: them to see more clearly in the dark.
//:
//: Tap that **moon** icon to compare how humans and cats see in the dark!

let cat = Sight.nocturnal(
    icons: ["🐈"],
    name: "Cat",
    dayEffect: .cat(day: true),
    nightEffect: .cat(day: false),
    magnetic: false
)

//: ## 🐂 Bulls
//:
//: Bulls have a very weak color perception and their vision is very blurry. So
//: when toreadors wave the red sheets, it's the movement, not the color that
//: bulls are after.

let bull = Sight.nocturnal(
    icons: ["🐂"],
    name: "Bull",
    dayEffect: .bull(day: true),
    nightEffect: .bull(day: false),
    magnetic: false
)

//: ## 🦅 Birds
//:
//: Birds have one of the most sophisticated eyes in the animal kingdom. They
//: actually have an additional cone for seeing violet and UV light. They use it
//: mainly for courtship and detecting pray, as some trails reflect it pretty
//: well.
//:
//: Migratory birds have an additional talent — they can see Earth's magnetic
//: fields! That's how they know where to go and how to come back during winter.

let eagle = Sight.nocturnal(
    icons: ["🦅"],
    name: "Eagle",
    dayEffect: .eagle(day: true),
    nightEffect: .eagle(day: false),
    magnetic: true
)

//: ## 🐍 Snakes
//:
//: While snakes have a very terrible color perception, their eyes can detect
//: movement. Some nocturnal snakes can also see infrared light and detect
//: heat emitted from their pray.
//:
//: Select the snake sight to see the simulation of how snakes perceive the
//: world!

let snake = Sight.nocturnal(
    icons: ["🐍"],
    name: "Snake",
    dayEffect: .snake(day: true),
    nightEffect: .snake(day: false),
    magnetic: false
)

//: ## 🐝 Bees
//:
//: The eyes of bees consist of thousands of other smaller eyes, each one
//: seeing the surroundings at a different angle. In addition, like birds, bees
//: have the ability to see UV light. They use it to find pollen in flowers and
//: they reflect it very strongly.

let bee = Sight.nocturnal(
    icons: ["🐝"],
    name: "Bee",
    dayEffect: .bee(day: true),
    nightEffect: .bee(day: false),
    magnetic: false
)

//: ## Make your own!
//:
//: You can use the effects library yourself to create a vision system for an
//: imaginary robot!

let robotEffect: Effect = .concat(
    .heatmap(),
    .blur(radius: 50),
    .saturation(adjustment: -1)
)

let robot = Sight.simple(
    icons: ["🤖"],
    name: "Robot",
    effect: robotEffect,
    magnetic: false
)

//: Time to add the sight configurations to the live view!

import PlaygroundSupport
import UIKit

let viewController = MainViewController()

viewController.leftSight = human

viewController.rightSights = [
    dog,
    cat,
    bull,
    eagle,
    snake,
    bee,
    robot
]

PlaygroundPage.current.liveView = viewController
