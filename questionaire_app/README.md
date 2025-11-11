# questionaire_app

# Problem Statement
1 . Build two screens with API implementation, and pixel perfect UI from the figma, each screen having its own features and state, with the brownie points items.

# Solution / Thought Process

1. Defined the structure for the project following clean Architecture
    a. Constants - Figma Colors defined with gradients, and borders
    b. Models - API response model 
    c. Screens - divided into two screens - Experience Screen and Onboarding Screen
        The screen with the API has it's repository, and BLoC file 
    d. Utility - To write the API call for each of it's type eg GET, POST
    e. Widgets - Common widgets being used by both the file like the buttons, textfield etc

2. Features Implemented for each screen
    1. Experience Screen
        a. Selections and deselection of each card with grayscale version of each image 
        b. Multi-line Text field with character limit of 250.(so the textfield has a property of maxLength, but displays a counter below, so working on removing it.)
        c. Multiple cards can be selected
        d. The experience id and the text is being saved and logged on pressing the next button for redirection
        
        Brownie Point - Feature

            UI/UX - Using all same colors, spacings, fonts from the Figma file
            UI is responsive 
            Keyboard part needs a bit of work

            State Management - Using BLoC to handle state management, easy to scale and simplifies clean architecture

            Animations - On selecting a card, the list animates and slides that card to first index. Working on smoothing it so looks clean
    
    2. Onboarding Question Screen
        a. Multi-line Text field with character limit of 600.
        b. Audio answer can be recorded
        c. Video answer can be recorded as well 
        d. Layout of all buttons, textfield and text is as per the design,
        e. Audio recording shows a waveform, using the audio_waveform package.
        f. Can delete the recorded audio or video
        g. Playback for audio and video is implemented.

        Brownie Points - Features

            Animation - as soon as the recording or video is done the buttons disappear with the Next button taking the full width. They come back as well on deleting the corresponding video or audio.
