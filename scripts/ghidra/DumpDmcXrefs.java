//@category D2Vault
import ghidra.app.script.GhidraScript;
import ghidra.app.decompiler.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.symbol.*;
import java.io.*;
import java.util.*;

public class DumpDmcXrefs extends GhidraScript {
    public void run() throws Exception {
        String path = getScriptArgs().length > 0 ? getScriptArgs()[0] : "/tmp/dmc-xrefs.txt";
        PrintWriter out = new PrintWriter(new FileWriter(path));
        DecompInterface decompiler = new DecompInterface();
        decompiler.openProgram(currentProgram);
        Listing listing = currentProgram.getListing();
        Set<Function> functions = new LinkedHashSet<>();

        DataIterator data = listing.getDefinedData(true);
        while (data.hasNext()) {
            Data item = data.next();
            if (!item.hasStringValue()) continue;
            String value = String.valueOf(item.getValue());
            String lower = value.toLowerCase();
            if (!(lower.contains("dmc") || lower.contains("qseecomstartapp (vk"))) continue;
            out.println("STRING " + item.getAddress() + " :: " + value.replace("\n", "\\n"));
            ReferenceIterator refs = currentProgram.getReferenceManager().getReferencesTo(item.getAddress());
            while (refs.hasNext()) {
                Reference ref = refs.next();
                Function function = listing.getFunctionContaining(ref.getFromAddress());
                out.println("  XREF " + ref.getFromAddress() + " :: " +
                    (function == null ? "<none>" : function.getName() + "@" + function.getEntryPoint()));
                if (function != null) functions.add(function);
            }
        }

        for (Function function : functions) {
            out.println("\n===== " + function.getName() + " @ " + function.getEntryPoint() + " =====");
            DecompileResults result = decompiler.decompileFunction(function, 120, monitor);
            out.println(result.decompileCompleted() ? result.getDecompiledFunction().getC() : result.getErrorMessage());
        }
        decompiler.dispose();
        out.close();
    }
}
