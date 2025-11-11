# questionaire_app

## Problem Statement
1. Build two screens with API implementation, and pixel perfect UI from the Figma, each screen having its own features and state, with the brownie points items.

## Solution / Thought Process

1. **Defined the structure for the project following Clean Architecture**
   - **Constants** – Figma colors defined with gradients and borders  
   - **Models** – API response model  
   - **Screens** – divided into two screens: **Experience Screen** and **Onboarding Screen**  
     - The screen with the API has its **repository** and **BLoC** file  
   - **Utility** – to write the API call for each of its types (e.g., GET, POST)  
   - **Widgets** – common widgets used by both files like buttons, text fields, etc.  


## Features Implemented for Each Screen

### 1. Experience Screen

- Selections and deselection of each card with grayscale version of each image  
- Multi-line text field with character limit of 250 (the text field has a property of `maxLength`, but displays a counter below, so working on removing it)  
- Multiple cards can be selected  
- The experience ID and the text are saved and logged on pressing the Next button for redirection
- Added animation for selection and deselection showing grayscale to color version of image & vice-versa.
- Next Button Gradient activating based on selection of one or more cards as per Figma design
- TextField border activates based on typing  

#### **Brownie Points - Features**

- **UI/UX**
  - Using all same colors, spacings, and fonts from the Figma file  
  - UI is responsive  
  - Keyboard part is implemented but user has to scroll for the next button, so working on that to take the whole UI up with the button.

- **State Management**
  - Using **BLoC** to handle state management, easy to scale and simplifies clean architecture
  - Event - FetchExperiences
  - State - Initial, Loading, Loaded/Success, Error
  - BLoC - To manage the event - FetchExperience calling the repository and emitting the required states  

- **Animations**
  - On selecting a card, the list animates and slides that card to the first index  
  - Working on smoothing it so it looks clean  


### 2. Onboarding Question Screen

- Multi-line text field with character limit of 600  
- Audio answer can be recorded  
- Video answer can be recorded as well  
- Layout of all buttons, text field, and text is as per the design  
- Audio recording shows a waveform using the **audio_waveform** package, which also helps to display the waveform to check
- The video recording is getting stored on the device  
- Recorded audio or video can be deleted
- The Keyboard works perfect for this screen with disappearing on tapping outside as well as UI going above to make the space for keyboard
- Playback for both audio and video is implemented  

#### **Brownie Points - Features**

- **Animation**
  - As soon as the recording or video is done, the buttons disappear and the Next button takes the full width
  - If any of the both recording or video is done, Next button also displays the gradient with the animation mentioned above  
  - They come back as well on deleting the corresponding video or audio  
