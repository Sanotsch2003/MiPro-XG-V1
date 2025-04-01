from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QGraphicsView, QGraphicsScene, QGraphicsRectItem, QGraphicsTextItem,
    QPushButton, QVBoxLayout, QWidget, QHBoxLayout, QComboBox, QMessageBox
)
from PyQt5.QtCore import Qt, pyqtSignal, QObject
from PyQt5.QtGui import QPainter, QFont, QFontMetrics, QPen, QColor
from PyQt5.QtSvg import QGraphicsSvgItem
import os
import platform
import serial
from serial.tools import list_ports
import threading
import time

#If you are encountering issues with PyQt5 on Linux, try uncommenting one or both of the following lines:
if platform.system() == "Linux":
    os.environ["QT_QPA_PLATFORM"] = "xcb"
    os.environ["QT_XCB_GL_INTEGRATION"] = "none"

scriptDir = os.path.dirname(os.path.abspath(__file__))
svgPath = os.path.join(scriptDir, "HardwareArchitecture.svg")

class ZoomableGraphicsView(QGraphicsView):
    def __init__(self, scene):
        super().__init__(scene)
        self.setDragMode(QGraphicsView.ScrollHandDrag)
        self.setTransformationAnchor(QGraphicsView.AnchorUnderMouse)
        self.setRenderHints(QPainter.Antialiasing | QPainter.TextAntialiasing)
        
        # Track the minimum zoom factor (1.0 = original size)
        self.minimumZoomFactor = 1.0

    def wheelEvent(self, event):
        zoomFactor = 1.2  # Zoom factor for each wheel step

        # Calculate the proposed zoom factor
        if event.angleDelta().y() > 0:
            proposedZoom = self.transform().m11() * zoomFactor  # Zoom in
        else:
            proposedZoom = self.transform().m11() / zoomFactor  # Zoom out

        # Enforce the minimum zoom level
        if proposedZoom < self.minimumZoomFactor:
            return  # Do not zoom out further than the minimum

        # Apply the zoom
        if event.angleDelta().y() > 0:
            self.scale(zoomFactor, zoomFactor)
        else:
            self.scale(1 / zoomFactor, 1 / zoomFactor)

class MainWindow(QMainWindow):
    def __init__(self, baudrate):
        super().__init__()
        self.baudrate = baudrate
        self.scene = QGraphicsScene()
        self.view = ZoomableGraphicsView(self.scene)

        # Create a central widget and layout
        centralWidget = QWidget()
        layout = QVBoxLayout()
        centralWidget.setLayout(layout)
        self.setCentralWidget(centralWidget)

        # Add a horizontal layout for buttons and dropdown
        topLayout = QHBoxLayout()
        layout.addLayout(topLayout)

        # Add a button to switch formats
        self.formatButton = QPushButton("Switch Format (Hex)")
        self.formatButton.setStyleSheet("QPushButton { padding: 5px; font-size: 12px; }")
        self.formatButton.clicked.connect(self.switchFormat)
        topLayout.addWidget(self.formatButton)

        # Add a dropdown for serial devices
        self.serialDropdown = QComboBox()
        self.serialDropdown.setStyleSheet("QComboBox { padding: 5px; font-size: 12px; }")
        self.populateSerialDropdown()
        topLayout.addWidget(self.serialDropdown)

        # Add a button to refresh the serial dropdown
        self.refreshButton = QPushButton("Refresh Ports")
        self.refreshButton.setStyleSheet("QPushButton { padding: 5px; font-size: 12px; }")
        self.refreshButton.clicked.connect(self.populateSerialDropdown)
        topLayout.addWidget(self.refreshButton)

        # Add a button to connect to the selected serial device
        self.connectButton = QPushButton("Connect to Serial Device")
        self.connectButton.setStyleSheet("QPushButton { padding: 5px; font-size: 12px; }")
        self.connectButton.clicked.connect(self.connectToSerialDevice)
        topLayout.addWidget(self.connectButton)

        # Add the graphics view to the layout
        layout.addWidget(self.view)

        # Initialize format tracking
        self.currentFormat = "hex"  # Options: "hex", "bin", "signed_dec", "unsigned_dec"

        # Create diagram and store signal mappings
        self.signalItems = self.createProcessorDiagram(self.scene)
        self.updateFontSizes()

        # Serial connection
        self.serialConnection = None
        self.serialReader = None

    def createProcessorDiagram(self, scene):
        items = {}
        # Load the SVG file
        svgItem = QGraphicsSvgItem(svgPath)
        svgItem.setPos(0, 0)  # Set position
        scene.addItem(svgItem)  # Add to the scene

        #create GPR items
        startX = 10
        startY = 337
        width = 80
        gap = 10
        for i in range(4):
            for j in range(4):
                name = f"GPR{j*4 + i}"
                if j*4 + i == 13:
                    name = f"LR"
                elif j*4 + i == 14:
                    name = f"SP"
                elif j*4 + i == 15:
                    name = f"PC"
                

                # Create square
                rectangle = QGraphicsRectItem(startX + i * (width + gap), startY + j * (width + gap), width, width)
                rectangle.setBrush(Qt.white)
                scene.addItem(rectangle)
                items[f"{name}rectangle"] = rectangle

                # Create title (positioned at the top left inside the square)
                title = QGraphicsTextItem(name)
                title.setPos(startX + i * (width + gap) + 2, startY + j * (width + gap) + 2)  # Small offset from top-left
                scene.addItem(title)
                items[f"{name}Title"] = title

                # Create value text
                valueText = "0x00000000"
                value = QGraphicsTextItem(valueText)
                scene.addItem(value)
                items[f"{name}Value"] = value

        #create Memory Interface items:
        startX = 426
        startY = 88
        widths = [120, 120, 120, 90, 90]
        height = 60
        names = ["Address", "Data To Memory", "Data From Memory", "Write Request", "Read Request"]
        gap = 10
        for i in range(5):
            name = f"{names[i]}"

            x = startX
            for j in range(i):
                x = x + gap + widths[j]


            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(Qt.white)
            scene.addItem(rectangle)
            items[f"MemoryInterface{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x + 2, startY + 2)  # Small offset from top-left
            scene.addItem(title)
            items[f"MemoryInterface{name}Title"] = title

            # Create value text
            valueText = "0x00000000"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"MemoryInterface{name}Value"] = value

        #create Control Unit items:
        startX = 10
        startY = 777
        widths = [120, 120, 120, 120]
        height = 60
        names = ["State", "Instruction", "Flags", "Immediate Data"]
        gap = 10
        for i in range(4):
            name = f"{names[i]}"

            x = startX
            for j in range(i):
                x = x + gap + widths[j]


            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(Qt.white)
            scene.addItem(rectangle)
            items[f"ControlUnit{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x + 2, startY + 2)  # Small offset from top-left
            scene.addItem(title)
            items[f"ControlUnit{name}Title"] = title

            if i == 2:
                continue

            # Create value text
            valueText = "0x00000000"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"ControlUnit{name}Value"] = value

        #Create Control Unit Flag items
        startX = 270
        startY = 800
        widths = [30, 30, 30, 30]
        height = 30
        names = ["Zero", "Negative", "Overflow", "Carry"]
        gap = 0
        for i in range(4):
            name = f"{names[i]}"

            x = startX
            for j in range(i):
                x = x + gap + widths[j]


            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(Qt.white)
            scene.addItem(rectangle)
            items[f"ControlUnit{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x, startY)  # Small offset from top-left
            font = QFont("Arial", 4)
            title.setFont(font)
            scene.addItem(title)
            items[f"ControlUnit{name}Title"] = title

            # Create value text
            valueText = "0x0"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"ControlUnit{name}Value"] = value

        #create Seven Segment Display items:
        startX = 970
        startY = 267
        widths = [120, 120, 50, 60, 60, 70]
        height = 60
        names = ["Data", "Prescaler", "ON/OFF", "Hex-Mode", "Signed-Mode", "Num Displays"]
        gap = 10
        for i in range(6):
            name = f"{names[i]}"

            x = startX
            for j in range(i):
                x = x + gap + widths[j]


            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(Qt.white)
            scene.addItem(rectangle)
            items[f"SevenSegmentDisplay{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x + 2, startY + 2)  # Small offset from top-left
            if i > 1:   
                font = QFont("Arial", 6)
                title.setFont(font)

            scene.addItem(title)
            items[f"SevenSegmentDisplay{name}Title"] = title

            # Create value text
            valueText = "0x00000000"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"SevenSegmentDisplay{name}Value"] = value


        # Create Hardware Timer items 

        for i in range(4):
            startX = 970
            startY = 367+i*100
            widths = [130, 120, 120, 130]
            height = 60
            names = ["Prescaler", "Max-Count", "Mode", "Count"]
            gap = 10
            for j in range(4):
                name = f"{names[j]}"
                x = startX
                for k in range(j):
                    x = x + gap + widths[k]

                rectangle = QGraphicsRectItem(x, startY, widths[j], height)
                rectangle.setBrush(Qt.white)
                scene.addItem(rectangle)
                items[f"HardwareTimer{i}{name}rectangle"] = rectangle

                # Create title (positioned at the top left inside the square)
                title = QGraphicsTextItem(name)
                title.setPos(x + 2, startY + 2)  # Small offset from top-left
                scene.addItem(title)
                items[f"HardwareTimer{i}{name}Title"] = title

                # Create value text
                valueText = "0x00000000"
                value = QGraphicsTextItem(valueText)
                scene.addItem(value)
                items[f"HardwareTimer{i}{name}Value"] = value

        # Create IO Pins Items
        startX = 970
        startY = 767
        widths = [57.6 for i in range(8)]
        height = 60
        names = ["IO-0", "IO-1", "IO-2", "IO-3", "IO-4", "IO-5", "IO-6", "IO-7"]
        gap = 10
        for i in range(8):
            name = f"{names[i]}"
            x = startX
            for j in range(i):
                x = x + gap + widths[j]

            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(QColor(255, 0, 0))
            scene.addItem(rectangle)
            items[f"{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x + 2, startY + 2)  # Small offset from top-left
            scene.addItem(title)
            items[f"{name}Title"] = title

            # Create value text
            valueText = "0x00000000"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"{name}Value"] = value


        # Create ALU items
        startX = 561
        startY = 646
        widths = [120, 120]
        height = 60
        names = ["Operand1", "Operand2"]
        gap = 70
        for i in range(2):
            name = f"{names[i]}"

            x = startX
            for j in range(i):
                x = x + gap + widths[j]


            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(Qt.white)
            scene.addItem(rectangle)
            items[f"ALU{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x + 2, startY + 2)  # Small offset from top-left
            if i > 1:   
                font = QFont("Arial", 6)
                title.setFont(font)

            scene.addItem(title)
            items[f"ALU{name}Title"] = title

            # Create value text
            valueText = "0x00000000"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"ALU{name}Value"] = value

        # Create ALU items
        startX = 490
        startY = 416
        widths = [120, 148]
        height = 60
        names = ["Flags", "Operation"]
        gap = 32
        for i in range(2):
            name = f"{names[i]}"

            x = startX
            for j in range(i):
                x = x + gap + widths[j]


            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(Qt.white)
            scene.addItem(rectangle)
            items[f"ALU{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x + 2, startY + 2)  # Small offset from top-left
            if i > 1:   
                font = QFont("Arial", 6)
                title.setFont(font)

            scene.addItem(title)
            items[f"ALU{name}Title"] = title

            if i == 0:
                continue
            # Create value text
            valueText = "0x00000000"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"ALU{name}Value"] = value


        #ALU output
        startX = 656 
        startY = 298
        width = 120
        height = 60
        gap = 0
        name = f"Data Output"
        x = startX
        rectangle = QGraphicsRectItem(x, startY, width, height)
        rectangle.setBrush(Qt.white)
        scene.addItem(rectangle)
        items[f"ALU{name}rectangle"] = rectangle

        # Create title (positioned at the top left inside the square)
        title = QGraphicsTextItem(name)
        title.setPos(x + 2, startY + 2)  # Small offset from top-left
        scene.addItem(title)
        items[f"ALU{name}Title"] = title

        # Create value text
        valueText = "0x00000000"
        value = QGraphicsTextItem(valueText)
        scene.addItem(value)
        items[f"ALU{name}Value"] = value

        #create ALU flags
        startX = 490
        startY = 442
        widths = [30, 30, 30, 30]
        height = 30
        names = ["Zero", "Negative", "Overflow", "Carry"]
        gap = 0
        for i in range(4):
            name = f"{names[i]}"

            x = startX
            for j in range(i):
                x = x + gap + widths[j]


            rectangle = QGraphicsRectItem(x, startY, widths[i], height)
            rectangle.setBrush(Qt.white)
            scene.addItem(rectangle)
            items[f"ALU{name}rectangle"] = rectangle

            # Create title (positioned at the top left inside the square)
            title = QGraphicsTextItem(name)
            title.setPos(x, startY)  # Small offset from top-left
            font = QFont("Arial", 4)
            title.setFont(font)
            scene.addItem(title)
            items[f"ALU{name}Title"] = title

            # Create value text
            valueText = "0x0"
            value = QGraphicsTextItem(valueText)
            scene.addItem(value)
            items[f"ALU{name}Value"] = value

        #ALU Manipulated Operand 2
        startX = 750 
        startY = 507
        width = 120
        height = 60
        gap = 0
        name = f"Manipulated Operand 2"
        x = startX
        rectangle = QGraphicsRectItem(x, startY, width, height)
        rectangle.setBrush(Qt.white)
        scene.addItem(rectangle)
        items[f"ALU{name}rectangle"] = rectangle

        # Create title (positioned at the top left inside the square)
        title = QGraphicsTextItem(name)
        title.setPos(x + 2, startY + 2)  # Small offset from top-left
        font = QFont("Arial", 7)
        title.setFont(font)
        scene.addItem(title)
        items[f"ALU{name}Title"] = title

        # Create value text
        valueText = "0x00000000"
        value = QGraphicsTextItem(valueText)
        scene.addItem(value)
        items[f"ALU{name}Value"] = value


        #ALU Bit Manipulation Method
        startX = 768 
        startY = 580
        width = 85
        height = 30
        gap = 0
        name = f"Bit Manipulation Method"
        x = startX
        rectangle = QGraphicsRectItem(x, startY, width, height)
        rectangle.setBrush(Qt.white)
        rectangle.setPen(QPen(Qt.NoPen))
        scene.addItem(rectangle)
        items[f"ALU{name}rectangle"] = rectangle

        # Create value text
        valueText = "ROTATE LEFT by"
        value = QGraphicsTextItem(valueText)
        scene.addItem(value)
        items[f"ALU{name}Value"] = value

        #ALU Bit Manipulation Value
        startX = 768 
        startY = 610
        width = 85
        height = 30
        gap = 0
        name = f"Bit Manipulation Value"
        x = startX
        rectangle = QGraphicsRectItem(x, startY, width, height)
        rectangle.setBrush(Qt.white)
        rectangle.setPen(QPen(Qt.NoPen))
        scene.addItem(rectangle)
        items[f"ALU{name}rectangle"] = rectangle

        # Create value text
        valueText = "0x0000"
        value = QGraphicsTextItem(valueText)
        scene.addItem(value)
        items[f"ALU{name}Value"] = value
        
        return items
    
    def switchFormat(self):
        # Cycle through the available formats
        formats = ["hex", "bin", "signed_dec", "unsigned_dec"]
        currentIndex = formats.index(self.currentFormat)
        nextIndex = (currentIndex + 1) % len(formats)
        self.currentFormat = formats[nextIndex]

        # Update the button text
        self.formatButton.setText(f"Switch Format ({self.currentFormat})")

    def updateFontSizes(self):
        for key in self.signalItems:
            if key.endswith("Value"):
                valueText = self.signalItems[key].toPlainText()
                name = key[:-5]
                boxKey = f"{name}rectangle"
                box = self.signalItems[boxKey]
                width = box.rect().width()
                height = box.rect().height()
                x = box.rect().x()
                y = box.rect().y()
                
                maxFontSize = 20
                fontSize = 1
                while True:
                    font = QFont("Arial", fontSize)
                    fm = QFontMetrics(font)
                    textWidth = fm.horizontalAdvance(valueText)
                    textHeight = fm.height()
                    if textWidth > width - 4 or textHeight > height - 4:  # Allow small padding
                        break  # Stop when text is too large
                    fontSize += 1  # Increase font size iteratively
                
                # Set the largest possible font size that fits
                font.setPointSize(min(fontSize, maxFontSize)-1)
                self.signalItems[key].setFont(font)

                # Recalculate dimensions with the final font size
                fm = QFontMetrics(font)
                textWidth = fm.horizontalAdvance(valueText)
                textHeight = fm.height()

                # Center text inside the square
                center_x = (x + width/2 - textWidth/2)
                center_y = (y + height/2 - textHeight/2)
                self.signalItems[key].setPos(center_x-2, center_y)

    def updateUI(self, data):
        for key in self.signalItems:
            if key.endswith("Value"):
                try:
                    value = data[key]

                    if key == "ControlUnitStateValue":
                        states = ["SETUP", "FETCH SETUP", "FETCH MEM.READ", "DECODE", "EXECUTE", "MEM. ACCESS", "WRITE BACK"]
                        self.signalItems[key].setPlainText(states[value])
                    elif key == "ALUOperationValue":
                        operations = ["AND", "EX. OR", "OR", "AND NOT", "NOT", "SUBTRACT", "REVERSE SUBTR.", "ADD", "ADD w. CARRY", "SUBTR. w. CARRY", "REVERSE SUBTR. w. CARRY", "MOVE", "SIGNED MULTIPLICATION", "UNSIGNED MULTIPLICATION"]
                        self.signalItems[key].setPlainText(operations[value])
                    elif key == "ALUBit Manipulation MethodValue":
                        bitManipulationMethods = ["ROTATE LEFT by:", "SHIFT LEFT by:", "SHIFT RIGHT by:", "SHIFT RIGHT (ARITH.) by:"]
                        self.signalItems[key].setPlainText(bitManipulationMethods[value])
                    elif key in [f"HardwareTimer{i}ModeValue" for i in range(4)]:
                        hardwareTimerModes = ["OFF", "Free Running", "One Shot", "Periodic"]
                        self.signalItems[key].setPlainText(hardwareTimerModes[value])
                    elif key in [f"IO-{i}Value" for i in range(8)]:
                        IO_PinModes = ["Output", "Input", "PWM"]
                        mode = IO_PinModes[value]
                        self.signalItems[key].setPlainText(mode)
                        index = key[3]
                        pinData = data[f"IO-{index}DataValue"]
                        dutyCycle = data[f"IO-{index}DutyCycleValue"]
                        if mode in ["Output", "Input"]:
                            if pinData == 1:
                                self.signalItems[f"IO-{index}rectangle"].setBrush(QColor(0, 255, 0))
                            else:
                                self.signalItems[f"IO-{index}rectangle"].setBrush(QColor(255, 0, 0))
                        else:
                            self.signalItems[f"IO-{index}rectangle"].setBrush(QColor(255-dutyCycle, 255, 255-dutyCycle))

                    else:
                        formattedValue = self.formatValue(value, self.currentFormat)
                        self.signalItems[key].setPlainText(str(formattedValue))

                    # Set colors


                except:
                    self.signalItems[key].setPlainText("Error")


        self.updateFontSizes()
             
    def formatValue(self, value, format):
        # Convert the value to the selected format
        if format == "hex":
            return f"0x{value:04X}" if value > 0xFF else f"0x{value:02X}"
        elif format == "bin":
            return f"0b{value:016b}" if value > 0xFF else f"0b{value:08b}"
        elif format == "signed_dec":
            return f"{value if value <= 0x7FFF else value - 0x10000}"
        elif format == "unsigned_dec":
            return f"{value}"
        else:
            return f"0x{value:04X}"  # Default to hex

    def populateSerialDropdown(self):
        # Clear the dropdown
        self.serialDropdown.clear()

        # List all available serial ports
        ports = self.listUSBSerialPorts()
        for port in ports:
            self.serialDropdown.addItem(port)

    def connectToSerialDevice(self):
        # Get the selected serial port
        selectedPort = self.serialDropdown.currentText()

        if not selectedPort:
            QMessageBox.warning(self, "Error", "No serial port selected!")
            return

        try:
            # Attempt to connect to the serial port
            self.serialReader = SerialReader(port=selectedPort, baudrate=self.baudrate)
            self.serialReader.dataReceived.connect(self.updateUI)
            self.thread = threading.Thread(target=self.serialReader.readSerialData, daemon=True)
            self.thread.start()
            QMessageBox.information(self, "Success", f"Connected to {selectedPort}!")
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to connect to {selectedPort}: {str(e)}")

    def listUSBSerialPorts(self):
        """Lists available USB-to-serial ports."""
        ports = list_ports.comports()
        usb_ports = [port.device for port in ports if 'USB' in str(port.device)]
        return usb_ports
    
class SerialReader(QObject):
    dataReceived = pyqtSignal(dict)  # Signal to send updated data to GUI
    DEBUG_DELIMITER = "11111111"

    def __init__(self, port, baudrate):
        super().__init__()
        self.serialPort = serial.Serial(port, baudrate, timeout=1)
        self.running = True
        self.dataList = []
        self.componentValues = {}
        self.dataLength = None

    def readSerialData(self):
        byteSinceReset = 0
        while self.running == True:
            #time.sleep(0.0001)
            if self.serialPort.in_waiting > 0:
                # Read exactly one byte
                byte = self.serialPort.read(1)  
                if byte:  # Ensure the byte is not empty
                    binary_string = format(ord(byte), '08b')  # Decode the byte to a string
                    # Check for the DEBUG_DELIMITER
                    if binary_string == self.DEBUG_DELIMITER:
                        newDataLength = byteSinceReset * 7
                        byteSinceReset = 0
                        if not newDataLength == self.dataLength:
                            self.dataLength = newDataLength
                            self.dataList = [0 for _ in range(self.dataLength)]
                        else:
                            try:
                                l = self.dataLength
                                #Getting Register Values:
                                for i in range(4):
                                    for j in range(4):
                                        number = j*4 + i
                                        name = f"GPR{number}"
                                        if number == 13:
                                            name = f"LR"
                                        elif number == 14:
                                            name = f"SP"
                                        elif number == 15:
                                            name = f"PC"

                                        name = f"{name}Value"
                                        self.componentValues[name] = self.convertToBinary(l-1049+32*number, l-1080 + 32*number)
                                
                                                                # Get ALU Values:
                                self.componentValues["ALUOperand1Value"] = self.convertToBinary(l-1081, l-1112)
                                self.componentValues["ALUOperand2Value"] = self.convertToBinary(l-1113, l-1144)
                                self.componentValues["ALUOperationValue"] = self.convertToBinary(l-1243, l-1246)
                                self.componentValues["ALUData OutputValue"] = self.convertToBinary(l-505, l-536)
                                self.componentValues["ALUBit Manipulation MethodValue"] = self.convertToBinary(l-1236, l-1237)
                                self.componentValues["ALUBit Manipulation ValueValue"] = self.convertToBinary(l-1238, l-1242)
                                self.componentValues["ALUZeroValue"] = self.convertToBinary(l-469, l-469)
                                self.componentValues["ALUNegativeValue"] = self.convertToBinary(l-470, l-470)
                                self.componentValues["ALUOverflowValue"] = self.convertToBinary(l-471, l-471)
                                self.componentValues["ALUCarryValue"] = self.convertToBinary(l-472, l-472)
                                self.componentValues["ALUManipulated Operand 2Value"] = self.convertToBinary(l-473, l-504)

                                # Get Memory Values:304
                                self.componentValues["MemoryInterfaceAddressValue"] = self.convertToBinary(l-433, l-464)
                                self.componentValues["MemoryInterfaceData To MemoryValue"] = self.convertToBinary(l-1145, l-1176)
                                self.componentValues["MemoryInterfaceData From MemoryValue"] = self.convertToBinary(l-1177, l-1208)
                                self.componentValues["MemoryInterfaceWrite RequestValue"] = self.convertToBinary(l-1299, l-1299)
                                self.componentValues["MemoryInterfaceRead RequestValue"] = self.convertToBinary(l-1300, l-1300)
                                
                                # Get Control Unit Values:
                                self.componentValues["ControlUnitImmediate DataValue"] = self.convertToBinary(l-537, l-568)
                                self.componentValues["ControlUnitInstructionValue"] = self.convertToBinary(l-1260, l-1291)
                                self.componentValues["ControlUnitZeroValue"] = self.convertToBinary(l-1292, l-1292)
                                self.componentValues["ControlUnitNegativeValue"] = self.convertToBinary(l-1293, l-1293)
                                self.componentValues["ControlUnitOverflowValue"] = self.convertToBinary(l-1294, l-1294)
                                self.componentValues["ControlUnitCarryValue"] = self.convertToBinary(l-1295, l-1295)
                                self.componentValues["ControlUnitStateValue"] = self.convertToBinary(l-1296, l-1298)

                                # Get Seven Segment Display Values:
                                self.componentValues["SevenSegmentDisplayDataValue"] = self.convertToBinary(l-1, l-32)
                                self.componentValues["SevenSegmentDisplayPrescalerValue"] = self.convertToBinary(l-33, l-58)
                                self.componentValues["SevenSegmentDisplayON/OFFValue"] = self.convertToBinary(l-59, l-59)
                                self.componentValues["SevenSegmentDisplayHex-ModeValue"] = self.convertToBinary(l-60, l-60)
                                self.componentValues["SevenSegmentDisplaySigned-ModeValue"] = self.convertToBinary(l-61, l-61)
                                self.componentValues["SevenSegmentDisplayNum DisplaysValue"] = self.convertToBinary(l-62, l-64)

                                # Get Hardware Timer Values:
                                self.componentValues["HardwareTimer0PrescalerValue"] = self.convertToBinary(l-65, l-96)
                                self.componentValues["HardwareTimer0Max-CountValue"] = self.convertToBinary(l-97, l-104)
                                self.componentValues["HardwareTimer0ModeValue"] = self.convertToBinary(l-105, l-106)
                                self.componentValues["HardwareTimer0CountValue"] = self.convertToBinary(l-107, l-114)

                                self.componentValues["HardwareTimer1PrescalerValue"] = self.convertToBinary(l-115, l-146)
                                self.componentValues["HardwareTimer1Max-CountValue"] = self.convertToBinary(l-147, l-162)
                                self.componentValues["HardwareTimer1ModeValue"] = self.convertToBinary(l-163, l-164)
                                self.componentValues["HardwareTimer1CountValue"] = self.convertToBinary(l-165, l-180)

                                self.componentValues["HardwareTimer2PrescalerValue"] = self.convertToBinary(l-181, l-212)
                                self.componentValues["HardwareTimer2Max-CountValue"] = self.convertToBinary(l-213, l-228)
                                self.componentValues["HardwareTimer2ModeValue"] = self.convertToBinary(l-229, l-230)
                                self.componentValues["HardwareTimer2CountValue"] = self.convertToBinary(l-231, l-246)

                                self.componentValues["HardwareTimer3PrescalerValue"] = self.convertToBinary(l-247, l-278)
                                self.componentValues["HardwareTimer3Max-CountValue"] = self.convertToBinary(l-279, l-310)
                                self.componentValues["HardwareTimer3ModeValue"] = self.convertToBinary(l-311, l-312)
                                self.componentValues["HardwareTimer3CountValue"] = self.convertToBinary(l-313, l-344)

                                # Getting IO-Pin Values:
                                self.componentValues["IO-7Value"] = self.convertToBinary(l-345, l-346)
                                self.componentValues["IO-7DataValue"] = self.convertToBinary(l-347, l-347)
                                self.componentValues["IO-7DutyCycleValue"] = self.convertToBinary(l-348, l-355)

                                self.componentValues["IO-6Value"] = self.convertToBinary(l-356, l-357)
                                self.componentValues["IO-6DataValue"] = self.convertToBinary(l-358, l-358)
                                self.componentValues["IO-6DutyCycleValue"] = self.convertToBinary(l-359, l-366)

                                self.componentValues["IO-5Value"] = self.convertToBinary(l-367, l-368)
                                self.componentValues["IO-5DataValue"] = self.convertToBinary(l-369, l-369)
                                self.componentValues["IO-5DutyCycleValue"] = self.convertToBinary(l-370, l-377)

                                self.componentValues["IO-4Value"] = self.convertToBinary(l-378, l-379)
                                self.componentValues["IO-4DataValue"] = self.convertToBinary(l-380, l-380)
                                self.componentValues["IO-4DutyCycleValue"] = self.convertToBinary(l-381, l-388)

                                self.componentValues["IO-3Value"] = self.convertToBinary(l-389, l-390)
                                self.componentValues["IO-3DataValue"] = self.convertToBinary(l-391, l-391)
                                self.componentValues["IO-3DutyCycleValue"] = self.convertToBinary(l-392, l-399)

                                self.componentValues["IO-2Value"] = self.convertToBinary(l-400, l-401)
                                self.componentValues["IO-2DataValue"] = self.convertToBinary(l-402, l-402)
                                self.componentValues["IO-2DutyCycleValue"] = self.convertToBinary(l-403, l-410)

                                self.componentValues["IO-1Value"] = self.convertToBinary(l-411, l-412)
                                self.componentValues["IO-1DataValue"] = self.convertToBinary(l-413, l-413)
                                self.componentValues["IO-1DutyCycleValue"] = self.convertToBinary(l-414, l-421)

                                self.componentValues["IO-0Value"] = self.convertToBinary(l-422, l-423)
                                self.componentValues["IO-0DataValue"] = self.convertToBinary(l-424, l-424)
                                self.componentValues["IO-0DutyCycleValue"] = self.convertToBinary(l-425, l-432)

                            except Exception as e: 
                                print(f"Error: {e}")

                        self.dataReceived.emit(self.componentValues)

                    # Insert data into the shared dictionary
                    else:
                        if self.dataLength != None:
                            for i in range(7):
                                index = byteSinceReset*7+i
                                if index < self.dataLength:
                                    self.dataList[index] = binary_string[6-i]
                        byteSinceReset += 1  # Increment byte counter

    def stop(self):
        self.running = False
        self.serialPort.close()

    def convertToBinary(self, max, min):
        if max < min or min < 0 or max >= len(self.dataList):
            raise ValueError("Invalid index range")
        binaryStr = ''.join(self.dataList[max:min -1 :-1])
        return int(binaryStr, 2)

def debug(baudrate):
    print(f"Using baudrate: {baudrate}")
    app = QApplication([])
    window = MainWindow(baudrate)
    window.setGeometry(100, 100, 800, 600)
    window.show()
    app.exec_()
