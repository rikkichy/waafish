function cod -d "Convert documents with pandoc" -a input output
    if string match -qr '\.pdf$' -- $output
        pandoc $input --pdf-engine=typst -o $output
    else
        pandoc $input -o $output
    end
end
