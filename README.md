<div align="center">
    <picture>
        <img alt="mockup" src="./READMEImages/MRTMockup.png" width="260">
    </picture>
    <br>
    <br>
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="./READMEImages/MRTLogoWhite.png">
        <source media="(prefers-color-scheme: light)" srcset="./READMEImages/MRTLogo.png">
        <img alt="Logo" src="./READMEImages/MRTLogoWhite.png" width="320">
    </picture>
</div>
<br>
MyRaceTimer is an iPhone app that makes timing mountain bike races/timed trials easier than ever before. Originally created for use in the [Joaquin Miller Park Enduro](https://jmpenduro.com/), the app has since gone off to be used in many other events such as the Briones Winter Enduro. Currently, MyRaceTimer is undergoing beta testing before it is ready to be released.

## Background 
Before MyRaceTimer, there existed two ways of timing mountain bike races/timed trials: chip and manual timing. Chip timing involves the use of specialized RFID chips and gates which record the start and finish times of each racer. This information would then be loaded onto a computer to calculate the results. Unfortunately, while very accurate, due to all of the specialized equipment needed, chip timing is extremely expensive and difficult to set up putting it out of reach for most mountain biking events. These events would be left to the second method of race timing, manual timing. 

Manual timing works by manually writing down racer start and finish times on paper using a stopwatch. While this solution may seem easy at first, when it comes time to calculate results, many downsides become immediately apparent. To calculate results, the following steps are required:

1. Calculate the time between the recorded start and finish time for each racer on each timed segment.
2. Add up each racer’s time for each timed segment to get their overall time.
3. Handle DNFs (did not finish), DNSs (did not start), and penalties.
4. Sort all of the racers overall times to find the winners.

Even for small events with few racers, the amount of calculations and steps required to calculate the results makes it incredibly tedious and too error-prone to be successful. For most events, an alternative solution is needed.

Luckily, MyRaceTimer combines the best of both worlds for chip and manual timing. As an iPhone app, MyRaceTimer has the same computational accuracy of chip timing. Also, because the recordings are not on paper and are “born digital”, the app can automatically calculate the race results with perfect precision solving the issue of manual timing. Finally, because everyone has a phone, MyRaceTimer eliminates the need for any specialized and expensive equipment. 

| ![MyRaceTimerComparison](https://github.com/nikodittmar/MyRaceTimer/assets/77522904/e387303e-b043-4a3a-915d-3277dda2a8d2) | 
|:--:| 
| *MyRaceTimer compared to Chip Timing and Manual Timing* |
