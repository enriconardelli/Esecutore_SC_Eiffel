package framework;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.filter.ElementFilter;
import org.jdom.filter.Filter;
import org.jdom.input.SAXBuilder;
import org.jdom.Element;

public class GUICodeCreator {

	private static Element Parameters;
	
	private GUICodeCreator() {
		// with a private constructor instances of this class cannot be created,
		// which is what we want since the actual generation of code is made
		// through a class method
	}

	public static void create(String pSCName, List<String> variableNames, List<String> eventNames) throws IOException {
		//LEGGO I PARAMETRI
		Parameters=readConfFile(pSCName);
		
		//LEGGO IL DEFAULT
		String[] Def = getDefaultButton();
		
		//SALVO I NOMI, RICORDARE DEFAULT
		ArrayList<String> buttonNames= getEventNames();   //PROBLEMA: ATTRIBUTI MANCANTI E DEFAULT
		//PRENDO I COLORI
		ArrayList<String> colorsList= getcolors(Def[0]); //LI HO MESSI IN UPPERCASE
		//PRENDO I TOOLTIPS
		ArrayList<String> tooltipList=getTTList(Def[1]);
		//PARAMETRI DI FRAME
		String[] frameParam = new String[2];
		frameParam[0]=Parameters.getChild("frame").getChild("width").getValue();
		frameParam[1]=Parameters.getChild("frame").getChild("height").getValue();//QUESTI LI DEVO LEGGERE COME STRINGHE MA TANTO GLIELI DEVO SOLO FAR STAMPARE
		

		
		
		
		
 		BufferedWriter out = new BufferedWriter(new FileWriter(Conf.source_dir + Conf.filesep + pSCName + Conf.filesep + "ImplGUI.java"));
		String classContent = "";
		classContent = writePreambleAndImports(pSCName);
		classContent += Conf.linesep;
		classContent += writeSignatureAndConstructor(frameParam, buttonNames, colorsList, tooltipList); //HO DOVUTO AGGIUNGERE I PARAMETRO PER EVITARE DI CREARE  ATTRIBUTI 
																 //PER OGNI LISTA
		classContent += writeButtons(); //QUI POSSO TOGLIERE IL PARAMETRO
		classContent += writePanelsAndFields(variableNames);
		classContent += writeTextArea();
		classContent += writeGUIstartAndClassClosure();
		out.write(classContent);
		out.close();
	}

	private static String writePreambleAndImports(String pSCName) {
		// writing generated annotation and package declaration
		String result = "";
		result += "/*" + Conf.linesep;
		result += " * @generated" + Conf.linesep;
		result += " */" + Conf.linesep;
		result += "package " + pSCName + ";" + Conf.linesep + Conf.linesep;

		// writing imports
		result += "import java.util.HashMap;" + Conf.linesep; //MI SERVE QUESTO IMPORT PER LA HASH MAP
		result += "import java.awt.Color;" + Conf.linesep;
		result += "import java.awt.FlowLayout;" + Conf.linesep;
		result += "import javax.swing.BoxLayout;" + Conf.linesep;
		result += "import javax.swing.JButton;" + Conf.linesep;
		result += "import javax.swing.JFrame;" + Conf.linesep;
		result += "import javax.swing.JLabel;" + Conf.linesep;
		result += "import javax.swing.JPanel;" + Conf.linesep;
		result += "import javax.swing.JScrollPane;" + Conf.linesep;
		result += "import javax.swing.JTextField;" + Conf.linesep;
		result += "import javax.swing.ScrollPaneConstants;" + Conf.linesep;
		result += "import javax.swing.JTextArea;" + Conf.linesep;
		result += "import core.AbstractGUI;" + Conf.linesep;
		return result;
	}

		private static String writeSignatureAndConstructor(String[] frameParam, ArrayList<String> buttonNames, ArrayList<String> colorsList, ArrayList<String> tooltipList) {
		String result = "";
		// writing class signature
		result += "public class ImplGUI extends AbstractGUI {" + Conf.linesep + Conf.linesep;
		
		//INSERISCO LA STAMPA DELLE LISTE TROVATE
		result += writeButtonList(buttonNames);
		result += writeColorList(colorsList);
		result += writeTTList(tooltipList);
		
		
		// writing constructor
		result += "\tpublic ImplGUI(String pSCName) {" + Conf.linesep + Conf.linesep;

		//INSERISCO LA HASH MAP DEL JFRAME
		result += "\t\tHashMap<String,Integer> frameParameters = new HashMap<String,Integer>();" + Conf.linesep;
		result += "\t\tString[] paramList = {" + "\"width\"" + ", " + "\"height\"" + "};" + Conf.linesep;
		result += "\t\tInteger[] valueList = {" + frameParam[0] + ", " + frameParam[1] + "};" + Conf.linesep;
		result += "\t\tfor (int i=0; i<paramList.length; i++) {" + Conf.linesep;
		result += "\t\t\t frameParameters.put(paramList[i], valueList[i]);" + Conf.linesep;
		result += "\t\t}" + Conf.linesep + Conf.linesep;
		
		result += "\t\tJFrame myFrame = new JFrame();" + Conf.linesep;
		result += "\t\tmyFrame.setTitle(pSCName);" + Conf.linesep;
		result += "\t\tmyFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);" + Conf.linesep;
		result += "\t\tmyFrame.setSize(frameParameters.get(" + "\"width\"" + "), frameParameters.get(" + "\"height\"" + "));" + Conf.linesep;
		result += "\t\tmyFrame.setLayout(new FlowLayout());" + Conf.linesep + Conf.linesep;
		return result;
	}

		private static String writeButtons() {
		String result = "";
		// writing buttons launching events labeling transitions
//		result += "\t\tString[] eventList = { ";
//		for (int j = 0; j < eventNames.size(); j++) {
//			result += "\"" + eventNames.get(j) + "\"";
//			if (j != eventNames.size() - 1)
//				result += ", ";
//		}
		
		
//		result += " };" + Conf.linesep;
		result += "\t\tfor (int i=0 ; i<eventList.length ; i++) {" + Conf.linesep;
		result += "\t\t\tJButton aButton = new JButton(\"LAUNCH \" + eventList[i]);" + Conf.linesep;
		result += "\t\t\taButton.setActionCommand(eventList[i]);" + Conf.linesep;
		result += "\t\t\taButton.setBackground(eventColorValue[i]);" + Conf.linesep;
		result += "\t\t\t aButton.setToolTipText(eventTTValue[i]);" + Conf.linesep;
		result += "\t\t\taButton.addActionListener(this);" + Conf.linesep;
		result += "\t\t\tmyFrame.getContentPane().add(aButton);" + Conf.linesep;
		result += "\t\t\teventButtons.put(eventList[i], aButton);" + Conf.linesep;
		result += "\t\t}" + Conf.linesep + Conf.linesep;
		return result;
	}

		private static String writePanelsAndFields(List<String> variableNames) {
		String result = "";
		// writing panels with labels and fields to display and change state values
		result += "\t\tString[] variableList = { ";
		for (int j = 0; j < variableNames.size(); j++) {
			result += "\"" + variableNames.get(j) + "\"";
			if (j != variableNames.size() - 1)
				result += ", ";
		}
		result += " };" + Conf.linesep;
		result += "\t\tfor (String variable : variableList) {" + Conf.linesep;
		result += "\t\t\tJPanel panel = new JPanel();" + Conf.linesep;
		result += "\t\t\tpanel.setBackground(Color.LIGHT_GRAY);" + Conf.linesep;
		result += "\t\t\tpanel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));" + Conf.linesep;
		result += "\t\t\tpanel.add(new JLabel(variable));" + Conf.linesep;
		result += "\t\t\tJTextField textField = new JTextField(\"\", 5);" + Conf.linesep;
		result += "\t\t\ttextField.setActionCommand(variable);" + Conf.linesep;
		result += "\t\t\ttextField.addActionListener(this);" + Conf.linesep;
		result += "\t\t\tpanel.add(textField);" + Conf.linesep;
		result += "\t\t\tmyFrame.getContentPane().add(panel);" + Conf.linesep;
		result += "\t\t\tvariableFields.put(variable, textField);" + Conf.linesep;
		result += "\t\t}" + Conf.linesep;
		return result;
	}

		private static String writeTextArea() {
		String result = "";
		// writing TextArea
		result += "\t\tstatechartTrace = new JTextArea(40,40);" + Conf.linesep;
		result += "\t\tstatechartTrace.setLineWrap(false);" + Conf.linesep;
		result += "\t\tJScrollPane aScroller = new JScrollPane(statechartTrace);" + Conf.linesep;
		result += "\t\taScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);" + Conf.linesep;
		result += "\t\taScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);" + Conf.linesep;
		result += "\t\tmyFrame.getContentPane().add(aScroller);" + Conf.linesep + Conf.linesep;
		return result;
	}

		private static String writeGUIstartAndClassClosure() {
		String result = "";
		// writing GUI start
		result += "\t\tmyFrame.setVisible(true);" + Conf.linesep;

		// closing class definition
		result += "\t}" + Conf.linesep + Conf.linesep;
		result += "\t}" + Conf.linesep;
		return result;
	}
		
		
		//DA QUI IN GIU' HO CREATO IO
		private static Element readConfFile(String file_name){
			//Legge il file dei parametri e lo salva in Parameters una variabile della classe
			File inputFile = new File(Conf.data_dir + Conf.filesep + Conf.param_dir + Conf.filesep + file_name + Conf.xml_conf_extension);
			Element documentRoot = Common.getDocumentRoot(inputFile);
			return documentRoot;	
			}
		
		private static ArrayList<String> getEventNames(){
			//Trova i nomi degli eventi, forse si pu� togliere dato che ce li ho in input
			//ma cos� � pi� facile generalizzare credo
			ArrayList<String> eventListNames= new ArrayList<String>();
			Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("button"));
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				eventListNames.add(currentElement.getAttributeValue("id"));
			}
			return eventListNames;
		}
			
		private static ArrayList<String> getcolors(String dcolor){
			//Trova la lista dei colori completando col default quando mancanti
			ArrayList<String> colorsList= new ArrayList<String>();
			Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("color"));
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				if (!currentElement.getAttributeValue("expr").isEmpty()){
					colorsList.add(currentElement.getAttributeValue("expr").toUpperCase());
				}else{
					colorsList.add(dcolor.toUpperCase());
				}
			}
			return colorsList;
		}
		
		private static ArrayList<String> getTTList(String dtooltip){
			//Trova la lista dei tooltip completando col default quando mancanti
			ArrayList<String> TTList= new ArrayList<String>();
			Iterator<Element> anElement = Parameters.getDescendants(new ElementFilter("tooltip"));
			while (anElement.hasNext()) {
				Element currentElement = anElement.next();
				if (!currentElement.getAttributeValue("expr").isEmpty()){
					TTList.add(currentElement.getAttributeValue("expr"));
				}else{
					TTList.add(dtooltip);
				}
				
			}
			return TTList;
		}
		
		private static String[] getDefaultButton(){
			//Trova i parametri di default dei button
			Element Default = Parameters.getChild("defaultb");
			Iterator<Element> col =Default.getDescendants(new ElementFilter("dcolor") );
			Element Col = col.next();
			String dcolor=Col.getAttributeValue("expr");
			
			Iterator<Element> tol =Default.getDescendants(new ElementFilter("dtooltip") );
			Element Tol = tol.next();
			String dtooltip = Tol.getAttributeValue("expr");
			String[] Ris = new String[2];
			Ris[0]=dcolor;
			Ris[1]=dtooltip;
			return Ris;
			
		}
		
		private static String writeButtonList(List<String> eventNames) {
			//Stampa sul file la lista dei bottoni
			String result = "";
			// writing the list of all buttons' names including the default 
			result += "\tprivate String[] eventList = { ";
			for (int j = 0; j < eventNames.size(); j++) {
				result += "\"" + eventNames.get(j) + "\"";
				if (j != eventNames.size() - 1)
					result += ", ";
			}
			result += " };" + Conf.linesep;
			return result;
		}
		
		private static String writeColorList(List<String> colorNames) {
			String result = "";
			// writing the list of all colors names  
			result += "\tprivate Color[] eventColorValue = { ";
			for (int j = 0; j < colorNames.size(); j++) {
				result +="Color." + colorNames.get(j);
				if (j != colorNames.size() - 1)
					result += ", ";
			}
			result += " };" + Conf.linesep;
			return result;
		}
		
		
		private static String writeTTList(List<String> toolTips) {
			String result = "";
			// writing the list of all tooltips 
			result += "\tprivate String[] eventTTValue = { ";
			for (int j = 0; j < toolTips.size(); j++) {
				result += "\"" + toolTips.get(j) + "\"";
				if (j != toolTips.size() - 1)
					result += ", ";
			}
			result += " };" + Conf.linesep;
			return result;
		}
		
		
}
