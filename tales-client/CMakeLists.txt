set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(PLUGIN "Mana")


set(QT_IMPORTS_DIR "/lib/${ARCH_TRIPLET}")


install(FILES lib/libmana/${ARCH_TRIPLET}/Mana/ServerListModel.qml DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)

install(FILES lib/libmana/${ARCH_TRIPLET}/Mana/qmldir DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)

install(FILES lib/libmana/${ARCH_TRIPLET}/Mana/libmana.so DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)


install(FILES lib/libmana/${ARCH_TRIPLET}/Mana/ServerListModel.qml DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN}/)
install(DIRECTORY example/qml/main DESTINATION /share)
