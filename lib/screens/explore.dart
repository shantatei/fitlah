import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Ink.image(
                      image: NetworkImage(
                          'https://web-back.perfectgym.com/sites/default/files/styles/460x/public/10-Brilliant-fitness-event-ideas-for-your-gym.jpg?itok=yesmpKvP'),
                      child: InkWell(
                        onTap: () {},
                      ),
                      height: 200,
                      width: 350,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      left: 16,
                      child: Text(
                        "Events",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Participate in any of these health events",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Ink.image(
                      image: NetworkImage(
                          'https://media.istockphoto.com/photos/vintage-cookbook-with-spices-and-herbs-on-rustic-wooden-background-picture-id1161153224?k=20&m=1161153224&s=612x612&w=0&h=dUAhyeGxsrNps3F10e28lOMadzJ8G50dJvwhdcoVJ4E='),
                      child: InkWell(
                        onTap: () {},
                      ),
                      height: 200,
                      width: 350,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      left: 16,
                      child: Text(
                        "Recipes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Find your favourite food recipes here",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
