cmake_minimum_required(VERSION 3.16)

project(chatApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.4)

qt_add_executable(appchatApp
    main.cpp
    NetworkSetup.h
    NetworkSetup.cpp
)

qt_add_qml_module(appchatApp
    URI chatApp
    VERSION 1.0
    QML_FILES
        Main.qml
        HomePage.qml
        Sidebar.qml
        ChatHeader.qml
        MessageList.qml
        MessageComposer.qml
        MembersPanel.qml
        TypingIndicator.qml
        MessageContextMenu.qml
        SettingsPanel.qml
        CreateRoomDialog.qml
        CodeSharePopup.qml
        RegistrationDialog.qml
)

set_target_properties(appchatApp PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.chatApp
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appchatApp
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appchatApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
