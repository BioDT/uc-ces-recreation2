about_html <- tags$div(
    tags$p(),
    tags$h4("Welcome to the BioDT Recreational Potential Model for Scotland!"),
    tags$p(),
    "This tool is intended help people explore and discover new areas of Scotland that are particularly suited to their specific recreational preferences.",
    "It was developed by the", tags$a(href = "https://www.ceh.ac.uk", "UK Centre for Ecology & Hydrology", target = "_blank"), "as part of the", tags$a(href = "https://biodt.eu/", "BioDT Prototype Digital Twins", target = "_blank"), "project.",
    tags$p(),
    tags$h4("What is Recreational Potential?"),
    "The Recreational Potential value is made up of 87", tags$em("items"), "representing distinct attributes of the land.",
    "The 87 items are grouped into four", tags$em("components"),
    tags$p(),
    tags$ul(
        tags$li(tags$strong("SLSRA:"), "Suitability of Land to Support Recreational Activity"),
        tags$li(tags$strong("FIPS_N:"), "Natural Features Influencing the Potential Provision"),
        tags$li(tags$strong("FIPS_I:"), "Infrastructure Features Influencing the Potential Provision"),
        tags$li(tags$strong("Water:"), "Rivers and lakes")
    ),
    "The Recreational Potential value is calculated by weighting each item by a", tags$em("score"), "that reflects the importance of that item to the user.",
    "A full set of 87 scores is referred to as a", tags$em("persona."),
    tags$p(),
    tags$h4("What does this tool do?"),
    "Given a persona, this tool can compute a Recreational Potential value between zero and one for each 20x20 metre square of land in Scotland, with higher values indicating greater Recreational Potential for that specific persona.",
    "These values are mapped to colours and displayed on the map of Scotland to your right.",
    tags$p(),
    tags$h4("How do I use this tool?"),
    "Detailed instructions can be found in the 'User Guide' tab.",
    tags$p(),
    "However, the essential steps are: (i) create a persona using the 'Persona' tab, (ii) draw a box on the map using the square orange button, and finally (iii) click the 'Update Map' button to compute the Recreational Potential value."
)

persona_html <- tags$div(
    tags$p(),
    "The 'Persona' tab contains everything you need to create, load, edit and save personas.",
    tags$p(),
    tags$h4("Creating a persona"),
    "Each of the nested tabs ('SLSRA', 'FIPS_N', 'FIPS_I', 'Water') contains a number of sliders, which are used for scoring the items.",
    tags$p(),
    "You will need to decide on a score, between 0 (of no importance) and 10 (of the highest importance), for each of the 87 items, according to the value of that item from your personal perspective.",
    "If, from the viewpoint of your persona, you do not feel that an item is relevant to the recreational potential, you should give it a score of 0.",
    tags$p(),
    "By default, all of the sliders are initialised with a score of 0.",
    "However, you are free to use an existing persona as a starting point, by first loading that persona before editing the scores as desired.",
    "For example, you could start from the 'Hard Recreationalist' or 'Soft Recreationalist' personas (user name 'examples').",
    "See 'Loading a persona' below.",
    tags$p(),
    tags$h4("Saving a persona"),
    "Each user is expected to create multiple personas, aligned to different recreational objectives (e.g. running alone versus walking with one's family).",
    "Since creating a persona takes a fair amount of effort, you can save personas for loading again in the future.",
    "To do so, click the 'Save Persona' button.",
    tags$p(),
    "If this is your first persona, enter a", tags$em("unique"), "user name into the 'New user' box.",
    "If you would prefer not to give your name, please use the username 'participant_XX' where 'XX' is your unique participant number.",
    "Otherwise, you can select your user name from the 'Existing user' dropdown menu.",
    tags$p(),
    "Next, enter a", tags$em("unique"), "name for the persona in the dialogue, and click 'Save'.",
    "Please note that you cannot override previously saved personas.",
    tags$p(),
    tags$h4("Loading a persona"),
    "You can load a persona by clicking the 'Load Persona' button.",
    "In the pop-up dialogue, you should select 'examples' as the user.",
    tags$p(),
    tags$h4("Next steps"),
    "Once you are happy with your persona scores, you are ready to run the computation.",
    "Go to the next tab 'Run the Model' to find out how to do this."
    # "Finally, note that you can view, load and, if you're not careful,", tags$em("overwrite"), "other users' personas.",
    # "Please be responsible!"
)

model_html <- tags$div(
    tags$p(),
    tags$h4("Selecting an area of interest"),
    "On the map to your right, navigate to an area (within Scotland!) of interested to you.",
    "Note that you can use the scroll wheel on your mouse to zoom in/out instead of the +/- buttons on the map.",
    tags$p(),
    "The square orange button on the left-hand-side of the map lets you draw rectangles on the map.",
    "Click on this button, click once to start drawing, and then drag your mouse across the map to draw a rectangle over an area of interest.",
    "When you are happy with the box that's been draw, click once more to stop drawing.",
    "If you need to start again, simply follow the same steps; when you draw a second box, the first box will disappear automatically.",
    tags$p(),
    "After drawing a box, some information will appear below the map.",
    "If all is well, this will just tell you the size of the area you have drawn.",
    "If there is a problem with your box (e.g. it is too large), you will need to draw another one.",
    tags$p(),
    tags$h4("Computing the Recreational Potential"),
    "You are now ready to click the orange 'Update Map' button.",
    "Once it has been calculated, the Recreational Potential value will be overlayed as a coloured 'heatmap' on top of the base map.",
    tags$p(),
    "Note that the model can take up to a minute to process larger areas.",
    tags$p(),
    tags$h4("Next steps"),
    "At this point you may want to adjust the displayed map to your liking.",
    "Go to the next tab 'Adjust the Visualisation' to find out how to do this."
)

viz_html <- tags$div(
    tags$p(),
    "Navigate to the 'Map Control' tab.",
    "This contains a small number of buttons and sliders for modifying the displayed data and base map.",
    tags$p(),
    tags$h4("Adjusting the displayed data"),
    "You can choose to display an individual component ('SLSRA', 'FIPS_N', 'FIPS_I', 'Water') of the Recreational Potential, instead of the full potential value, by clicking on the buttons.",
    "If you need reminding of what these components represent, see the 'About' tab.",
    tags$p(),
    "It can be useful to filter out low values to make it clearer where the regions of highest Recreational Potential are.",
    "You can do this by dragging the first slider 'Display values above' to a number greater than 0.",
    tags$p(),
    "Finally, you can adjust the opacity (transparency) of the data layer, which can be helpful for inspecting features of the underlying base map.",
    tags$p(),
    tags$h4("Changing the base map"),
    "The base map can also be changed by clicking on the buttons under 'Base map'.",
    "You are encouraged to play with the different options.",
    tags$p(),
    tags$h4("Next steps"),
    "Have fun! Play with different personas, areas, and map layers.",
    tags$p(),
    "If you have further questions, check the 'FAQ' tab.",
)

faq_html <- tags$div(
    tags$p(),
    tags$h3("Frequently Asked Questions"),
    "If you cannot find the answer to your question here, please reach out to Dr Jan Dick at jand@ceh.ac.uk.",
    tags$h4("What data does this model use?"),
    "to do",
    tags$h4("How are the values rescaled?"),
    "Note that a value of one (zero) represents the highest (lowest) Recreational Potential", tags$em("within the chosen area"), "and not the highest (lowest) value anywhere in Scotland.",
    tags$h4("Where can I find academic literature on this model?"),
    "to do"
)
