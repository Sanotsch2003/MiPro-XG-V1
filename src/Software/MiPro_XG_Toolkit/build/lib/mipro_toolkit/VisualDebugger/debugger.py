from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QGraphicsView, QGraphicsScene, QGraphicsRectItem, QGraphicsTextItem,
    QPushButton, QVBoxLayout, QWidget, QHBoxLayout, QComboBox, QMessageBox
)
from PyQt5.QtCore import Qt, QTimer, pyqtSignal, QObject
from PyQt5.QtGui import QPainter, QFont, QFontMetrics, QPen
from PyQt5.QtSvg import QGraphicsSvgItem, QSvgWidget
import os
import random
import serial
from serial.tools import list_ports
import sys
import threading
import serial
import time


# Set the platform to xcb (for Linux)
os.environ["QT_QPA_PLATFORM"] = "xcb"
scriptDir = os.path.dirname(os.path.abspath(__file__))
svgPath = os.path.join(scriptDir, "imgs", "HardwareArchitecture.svg")
#svgPath = os.path.join(scriptDir, "imgs", "HighLevelHardwareArchitecture.drawio.svg")

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

def createProcessorDiagram(scene):
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

            # Find the maximum font size that fits
            maxFontSize = 1
            while True:
                font = QFont("Arial", maxFontSize)
                fm = QFontMetrics(font)
                textWidth = fm.horizontalAdvance(valueText)
                textHeight = fm.height()

                if textWidth > width - 4 or textHeight > width - 4:  # Allow small padding
                    break  # Stop when text is too large
                maxFontSize += 1  # Increase font size iteratively

            # Set the largest possible font size that fits
            font.setPointSize(maxFontSize - 1)
            value.setFont(font)

            # Recalculate dimensions with the final font size
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            # Center text inside the square
            center_x = startX + i * (width + gap) + (width - textWidth) / 2
            center_y = startY + j * (width + gap) + (width - textHeight) / 2
            value.setPos(center_x-2, center_y)

            scene.addItem(value)
            items[f"{name}Value"] = value

    #create Memory Interface items:
    startX = 426
    startY = 88
    widths = [120, 120, 120, 90, 90]
    height = 60
    names = ["Address", "Data To Memory", "Data From Memory", "Write Request", "ReadRequest"]
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

        # Find the maximum font size that fits
        maxFontSize = 1
        while True:
            font = QFont("Arial", maxFontSize)
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            if textWidth > widths[i] - 4 or textHeight > height - 4:  # Allow small padding
                break  # Stop when text is too large
            maxFontSize += 1  # Increase font size iteratively

        # Set the largest possible font size that fits
        font.setPointSize(maxFontSize - 1)
        value.setFont(font)

        # Recalculate dimensions with the final font size
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        # Center text inside the square
        center_x = x + (widths[i] - textWidth) / 2
        center_y = startY + (height - textHeight) / 2
        value.setPos(center_x-3, center_y)

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

        # Find the maximum font size that fits
        maxFontSize = 1
        while True:
            font = QFont("Arial", maxFontSize)
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            if textWidth > widths[i] - 4 or textHeight > height - 4:  # Allow small padding
                break  # Stop when text is too large
            maxFontSize += 1  # Increase font size iteratively

        # Set the largest possible font size that fits
        font.setPointSize(maxFontSize - 1)
        value.setFont(font)

        # Recalculate dimensions with the final font size
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        # Center text inside the square
        center_x = x + (widths[i] - textWidth) / 2
        center_y = startY + (height - textHeight) / 2
        value.setPos(center_x-3, center_y)

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

        # Find the maximum font size that fits
        maxFontSize = 1
        while True:
            font = QFont("Arial", maxFontSize)
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            if textWidth > widths[i] - 4 or textHeight > height - 4:  # Allow small padding
                break  # Stop when text is too large
            maxFontSize += 1  # Increase font size iteratively

        # Set the largest possible font size that fits
        font.setPointSize(maxFontSize - 1)
        value.setFont(font)

        # Recalculate dimensions with the final font size
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        # Center text inside the square
        center_x = x + (widths[i] - textWidth) / 2
        center_y = startY + (height - textHeight) / 2
        value.setPos(center_x-3, center_y)

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

        # Find the maximum font size that fits
        maxFontSize = 1
        while True:
            font = QFont("Arial", maxFontSize)
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            if textWidth > widths[i] - 4 or textHeight > height - 4:  # Allow small padding
                break  # Stop when text is too large
            maxFontSize += 1  # Increase font size iteratively

        # Set the largest possible font size that fits
        font.setPointSize(maxFontSize - 1)
        value.setFont(font)

        # Recalculate dimensions with the final font size
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        # Center text inside the square
        center_x = x + (widths[i] - textWidth) / 2
        center_y = startY + (height - textHeight) / 2
        value.setPos(center_x-3, center_y)

        scene.addItem(value)
        items[f"SevenSegmentDisplay{name}Value"] = value

    #Create Clock Controller Item
    startX = 1176
    startY = 367
    width = 120
    height = 60
    gap = 0
    name = f"Prescaler"
    x = startX
    rectangle = QGraphicsRectItem(x, startY, width, height)
    rectangle.setBrush(Qt.white)
    scene.addItem(rectangle)
    items[f"ClockController{name}rectangle"] = rectangle

    # Create title (positioned at the top left inside the square)
    title = QGraphicsTextItem(name)
    title.setPos(x + 2, startY + 2)  # Small offset from top-left
    scene.addItem(title)
    items[f"ClockController{name}Title"] = title

    # Create value text
    valueText = "0x00000000"
    value = QGraphicsTextItem(valueText)

    # Find the maximum font size that fits
    maxFontSize = 1
    while True:
        font = QFont("Arial", maxFontSize)
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        if textWidth > width - 4 or textHeight > height - 4:  # Allow small padding
            break  # Stop when text is too large
        maxFontSize += 1  # Increase font size iteratively

    # Set the largest possible font size that fits
    font.setPointSize(maxFontSize - 1)
    value.setFont(font)

    # Recalculate dimensions with the final font size
    fm = QFontMetrics(font)
    textWidth = fm.horizontalAdvance(valueText)
    textHeight = fm.height()

    # Center text inside the square
    center_x = x + (width - textWidth) / 2
    center_y = startY + (height - textHeight) / 2
    value.setPos(center_x-3, center_y)

    scene.addItem(value)
    items[f"ClockController{name}Value"] = value

    #Create Serial Interface Item
    startX = 1176
    startY = 467
    width = 120
    height = 60
    gap = 0
    name = f"Prescaler"
    x = startX
    rectangle = QGraphicsRectItem(x, startY, width, height)
    rectangle.setBrush(Qt.white)
    scene.addItem(rectangle)
    items[f"SerialInterface{name}rectangle"] = rectangle

    # Create title (positioned at the top left inside the square)
    title = QGraphicsTextItem(name)
    title.setPos(x + 2, startY + 2)  # Small offset from top-left
    scene.addItem(title)
    items[f"SerialInterface{name}Title"] = title

    # Create value text
    valueText = "0x00000000"
    value = QGraphicsTextItem(valueText)

    # Find the maximum font size that fits
    maxFontSize = 1
    while True:
        font = QFont("Arial", maxFontSize)
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        if textWidth > width - 4 or textHeight > height - 4:  # Allow small padding
            break  # Stop when text is too large
        maxFontSize += 1  # Increase font size iteratively

    # Set the largest possible font size that fits
    font.setPointSize(maxFontSize - 1)
    value.setFont(font)

    # Recalculate dimensions with the final font size
    fm = QFontMetrics(font)
    textWidth = fm.horizontalAdvance(valueText)
    textHeight = fm.height()

    # Center text inside the square
    center_x = x + (width - textWidth) / 2
    center_y = startY + (height - textHeight) / 2
    value.setPos(center_x-3, center_y)

    scene.addItem(value)
    items[f"SerialInterface{name}Value"] = value

    # Create ALU items
    startX = 561
    startY = 648
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

        # Find the maximum font size that fits
        maxFontSize = 1
        while True:
            font = QFont("Arial", maxFontSize)
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            if textWidth > widths[i] - 4 or textHeight > height - 4:  # Allow small padding
                break  # Stop when text is too large
            maxFontSize += 1  # Increase font size iteratively

        # Set the largest possible font size that fits
        font.setPointSize(maxFontSize - 1)
        value.setFont(font)

        # Recalculate dimensions with the final font size
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        # Center text inside the square
        center_x = x + (widths[i] - textWidth) / 2
        center_y = startY + (height - textHeight) / 2
        value.setPos(center_x-3, center_y)

        scene.addItem(value)
        items[f"ALU{name}Value"] = value

    # Create ALU items
    startX = 490
    startY = 418
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

        # Find the maximum font size that fits
        maxFontSize = 1
        while True:
            font = QFont("Arial", maxFontSize)
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            if textWidth > widths[i] - 4 or textHeight > height - 4:  # Allow small padding
                break  # Stop when text is too large
            maxFontSize += 1  # Increase font size iteratively

        # Set the largest possible font size that fits
        font.setPointSize(maxFontSize - 1)
        value.setFont(font)

        # Recalculate dimensions with the final font size
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        # Center text inside the square
        center_x = x + (widths[i] - textWidth) / 2
        center_y = startY + (height - textHeight) / 2
        value.setPos(center_x-3, center_y)

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

    # Find the maximum font size that fits
    maxFontSize = 1
    while True:
        font = QFont("Arial", maxFontSize)
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        if textWidth > width - 4 or textHeight > height - 4:  # Allow small padding
            break  # Stop when text is too large
        maxFontSize += 1  # Increase font size iteratively

    # Set the largest possible font size that fits
    font.setPointSize(maxFontSize - 1)
    value.setFont(font)

    # Recalculate dimensions with the final font size
    fm = QFontMetrics(font)
    textWidth = fm.horizontalAdvance(valueText)
    textHeight = fm.height()

    # Center text inside the square
    center_x = x + (width - textWidth) / 2
    center_y = startY + (height - textHeight) / 2
    value.setPos(center_x-3, center_y)

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

        # Find the maximum font size that fits
        maxFontSize = 1
        while True:
            font = QFont("Arial", maxFontSize)
            fm = QFontMetrics(font)
            textWidth = fm.horizontalAdvance(valueText)
            textHeight = fm.height()

            if textWidth > widths[i] - 4 or textHeight > height - 4:  # Allow small padding
                break  # Stop when text is too large
            maxFontSize += 1  # Increase font size iteratively

        # Set the largest possible font size that fits
        font.setPointSize(maxFontSize - 1)
        value.setFont(font)

        # Recalculate dimensions with the final font size
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        # Center text inside the square
        center_x = x + (widths[i] - textWidth) / 2
        center_y = startY + (height - textHeight) / 2
        value.setPos(center_x-3, center_y)

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

    # Find the maximum font size that fits
    maxFontSize = 1
    while True:
        font = QFont("Arial", maxFontSize)
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        if textWidth > width - 4 or textHeight > height - 4:  # Allow small padding
            break  # Stop when text is too large
        maxFontSize += 1  # Increase font size iteratively

    # Set the largest possible font size that fits
    font.setPointSize(maxFontSize - 1)
    value.setFont(font)

    # Recalculate dimensions with the final font size
    fm = QFontMetrics(font)
    textWidth = fm.horizontalAdvance(valueText)
    textHeight = fm.height()

    # Center text inside the square
    center_x = x + (width - textWidth) / 2
    center_y = startY + (height - textHeight) / 2
    value.setPos(center_x-3, center_y)

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
    valueText = "Logical Shift Left by"
    value = QGraphicsTextItem(valueText)

    # Find the maximum font size that fits
    maxFontSize = 1
    while True:
        font = QFont("Arial", maxFontSize)
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        if textWidth > width - 4 or textHeight > height - 4:  # Allow small padding
            break  # Stop when text is too large
        maxFontSize += 1  # Increase font size iteratively

    # Set the largest possible font size that fits
    font.setPointSize(maxFontSize - 1)
    value.setFont(font)

    # Recalculate dimensions with the final font size
    fm = QFontMetrics(font)
    textWidth = fm.horizontalAdvance(valueText)
    textHeight = fm.height()

    # Center text inside the square
    center_x = x + (width - textWidth) / 2
    center_y = startY + (height - textHeight) / 2
    value.setPos(center_x-3, center_y)

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

    # Find the maximum font size that fits
    maxFontSize = 1
    while True:
        font = QFont("Arial", maxFontSize)
        fm = QFontMetrics(font)
        textWidth = fm.horizontalAdvance(valueText)
        textHeight = fm.height()

        if textWidth > width - 4 or textHeight > height - 4:  # Allow small padding
            break  # Stop when text is too large
        maxFontSize += 1  # Increase font size iteratively

    # Set the largest possible font size that fits
    font.setPointSize(maxFontSize - 1)
    value.setFont(font)

    # Recalculate dimensions with the final font size
    fm = QFontMetrics(font)
    textWidth = fm.horizontalAdvance(valueText)
    textHeight = fm.height()

    # Center text inside the square
    center_x = x + (width - textWidth) / 2
    center_y = startY + (height - textHeight) / 2
    value.setPos(center_x-3, center_y)

    scene.addItem(value)
    items[f"ALU{name}Value"] = value

    for key in items:
        print(key)
    
    return items

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
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
        self.signalItems = createProcessorDiagram(self.scene)

        # Serial connection
        self.serialConnection = None
        self.serialReader = None

    def switchFormat(self):
        # Cycle through the available formats
        formats = ["hex", "bin", "signed_dec", "unsigned_dec"]
        currentIndex = formats.index(self.currentFormat)
        nextIndex = (currentIndex + 1) % len(formats)
        self.currentFormat = formats[nextIndex]

        # Update the button text
        self.formatButton.setText(f"Switch Format ({self.currentFormat})")


    def updateUI(self, data):
        #print(data)
        # Generate dummy signal values
        dummySignals = {
            "ALU_OUT": random.randint(0, 0xFFFF),
            "REG_A": random.randint(0, 0xFF),
            "REG_B": random.randint(0, 0xFF),
        }

        # Update text items with new signal values in the selected format
        for name, value in dummySignals.items():
            if name in self.signalItems:
                formattedValue = self.formatValue(value, self.currentFormat)
                self.signalItems[name].setPlainText(f"{name}: {formattedValue}")

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
            self.serialReader = SerialReader(port=selectedPort)
            self.serialReader.dataReceived.connect(self.updateUI)
            self.thread = threading.Thread(target=self.serialReader.readSerialData, daemon=True)
            self.thread.start()
            QMessageBox.information(self, "Success", f"Connected to {selectedPort}!")
        except Exception as e:
            QMessageBox.critical(self, "Error", f"Failed to connect to {selectedPort}: {str(e)}")

    def listUSBSerialPorts(self):
        """Lists available USB-to-serial ports."""
        ports = list_ports.comports()
        usb_ports = [port.device for port in ports if 'USB' in port.description or 'usb' in port.description.lower()]
        return usb_ports
    
class SerialReader(QObject):
    """ Background thread to read serial data and update dictionary """
    dataReceived = pyqtSignal(dict)  # Signal to send updated data to GUI
    DEBUG_DELIMITER = "11111111"

    def __init__(self, port="/dev/ttyUSB0", baudrate=9600):
        super().__init__()
        self.serialPort = serial.Serial(port, baudrate, timeout=1)
        self.running = True
        #self.dataLen = 1008
        #self.dataList = [0 for _ in range(self.dataLen)] #shared list
        self.dataList = []
        componentValues = {}
        self.dataLength = None

    def readSerialData(self):
        byteSinceReset = 0
        while self.running == True:
            time.sleep(0.0001)
            if self.serialPort.in_waiting > 0:
                # Read exactly one byte
                byte = self.serialPort.read(1)  # Reads 1 byte
                if byte:  # Ensure the byte is not empty
                    binary_string = format(ord(byte), '08b')  # Decode the byte to a string
                    #print(binary_string)
                    # Check for the DEBUG_DELIMITER
                    if binary_string == self.DEBUG_DELIMITER:
                        #print("Debug delimiter detected")
                        newDataLength = byteSinceReset * 7
                        byteSinceReset = 0
                        if not newDataLength == self.dataLength:
                            print(newDataLength)
                            self.dataLength = newDataLength
                            self.dataList = [0 for _ in range(self.dataLength)]
                        else:
                            try:
                                l = self.dataLength
                                self.componentValues["SevenSegmentDisplayData"] = self.convertToBinary(l-1, l-32)
                                self.componentValues["SevenSegmentDisplayPrescaler"] = self.convertToBinary(l-33, l-58)
                                self.componentValues["SevenSegmentDisplayOn"] = self.convertToBinary(l-59, l-59)
                                self.componentValues["SevenSegmentDisplayHexMode"] = self.convertToBinary(l-60, l-60)
                                self.componentValues["SevenSegmentDisplayDataSignedMode"] = self.convertToBinary(l-61, l-61)
                                self.componentValues["SevenSegmentDisplayDataNumDisplays"] = self.convertToBinary(l-62, l-64)
                                self.componentValues["clockControllerPrescalerReg"] = self.convertToBinary(l-65, l-96)
                                self.componentValues["serialInterfacePrescalerReg"] = self.convertToBinary(l-97, l-128)
                                self.componentValues["dataFromALU"] = self.convertToBinary(l-129, l-160)
                                self.componentValues["ALU_flags"] = self.convertToBinary(l-161, l-164)
                                self.componentValues["ALU_debug"] = self.convertToBinary(l-165, l-264)
                                self.componentValues["dataFromRegisters"] = self.convertToBinary(l-265, l-776)
                                self.componentValues["operand1"] = self.convertToBinary(l-777, l-808)
                                self.componentValues["operand2"] = self.convertToBinary(l-809, l-840)
                                self.componentValues["dataToRegisters"] = self.convertToBinary(l-841, l-872)
                                self.componentValues["interruptHandlerAddress"] = self.convertToBinary(l-873, l-904)
                                self.componentValues["operand1Sel"] = self.convertToBinary(l-905, l-909)
                                self.componentValues["operand2Sel"] = self.convertToBinary(l-910, l-914)
                                self.componentValues["dataToRegistersSel"] = self.convertToBinary(l-915, l-915)
                                self.componentValues["loadRegistersSel"] = self.convertToBinary(l-916, l-931)
                                self.componentValues["bitManipulationCode"] = self.convertToBinary(l-932, l-933)
                                self.componentValues["bitManipulationValue"] = self.convertToBinary(l-934, l-938)
                                self.componentValues["ALU_opCode"] = self.convertToBinary(l-939, l-941)
                                self.componentValues["carryIn"] = self.convertToBinary(l-942, l-942)
                                self.componentValues["upperSel"] = self.convertToBinary(l-943, l-943)
                                self.componentValues["softwareResetFromCu"] = self.convertToBinary(l-944, l-944)
                                self.componentValues["clearInterrupts"] = self.convertToBinary(l-945, l-954)
                                self.componentValues["CU_debug"] = self.convertToBinary(l-955, l-1004)
                            except Exception as e: 
                                print(f"Error: {e}")

                        self.dataReceived.emit(self.componentValues)

                    else:
                        if self.dataLength != None:
                            # Insert data into the shared dictionary
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
        print(binaryStr)
        return int(binaryStr, 2)

if __name__ == "__main__":
    app = QApplication([])
    window = MainWindow()
    window.setGeometry(100, 100, 800, 600)
    window.show()
    app.exec_()