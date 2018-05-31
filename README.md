# qr-generator
QR code generation from a given CSV file containing a list of full name,
company, job description and e-mail.

## Usage
This QR code generator receives a CSV file as input. This CSV file should
contain 4 columns:
1. Full name
2. Company
3. Job description
4. E-mail

An example execution line is the following:
```bash
./qr.sh example.csv
```

**Note:** It is assumed that the CSV file does not have a header line.

## Output
Based on the example contained above, this script will generate a folder named
`example`. Inside this folder, 4 files will be generated:
1. 001\_Alice\_Appleseed.eps
2. 001\_Alice\_Appleseed.png
3. 002\_John\_Doe.eps
4. 002\_John\_Doe.png
