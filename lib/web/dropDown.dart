import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropD{
  static DropdownSearch<String> buildDropdownSearch(double h, double w, double maxH, List<String> contentList,
       Icon preIcon,Icon listIcon, String hint, String label, String? selectedItem, void Function(String?) onChanged) {
    return DropdownSearch<String>(
      popupProps: PopupProps.menu(
        showSearchBox: true,
        constraints: BoxConstraints(
          maxHeight: maxH,  // Adjust this value based on your requirement
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: 'Search here...',
            hintStyle: GoogleFonts.play(
                fontStyle: FontStyle.italic
            ),
            prefixIcon: Icon(Icons.search),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            // color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            child: Row(
              children: [
                listIcon,
                SizedBox(width: h/20),
                Text(
                  item,
                  style: GoogleFonts.play(
                    // color: isSelected ? Colors.blue : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      items: contentList,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.play(
              fontSize: h / 32,
              fontStyle: FontStyle.italic
          ),
          hintText: hint,
          hintStyle: GoogleFonts.play(
              fontSize: h / 32,
              fontStyle: FontStyle.italic
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(h/50),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(h/50),
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: preIcon,
        ),
      ),
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem ?? hint,
          style: GoogleFonts.play(
              fontSize: h/ 32,
              // color: Colors.white,
              fontStyle: FontStyle.italic
          ),
        );
      },
      dropdownButtonProps: DropdownButtonProps(
        icon: Icon(
          Icons.arrow_drop_down_circle,
          // color: Colors.white,
        ),
        splashRadius: 10,
      ),
      itemAsString: (String? item) => item ?? "",
      onChanged: onChanged,
      selectedItem: selectedItem,
    );
  }

}