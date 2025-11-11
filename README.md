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

#### **Brownie Points - Features**

- **UI/UX**
  - Using all same colors, spacings, and fonts from the Figma file  
  - UI is responsive  
  - Keyboard part needs a bit of work  

- **State Management**
  - Using **BLoC** to handle state management, easy to scale and simplifies clean architecture  

- **Animations**
  - On selecting a card, the list animates and slides that card to the first index  
  - Working on smoothing it so it looks clean  


### 2. Onboarding Question Screen

- Multi-line text field with character limit of 600  
- Audio answer can be recorded  
- Video answer can be recorded as well  
- Layout of all buttons, text field, and text is as per the design  
- Audio recording shows a waveform using the **audio_waveform** package  
- Recorded audio or video can be deleted  
- Playback for both audio and video is implemented  

#### **Brownie Points - Features**

- **Animation**
  - As soon as the recording or video is done, the buttons disappear and the Next button takes the full width  
  - They come back as well on deleting the corresponding video or audio  
