# Creating locale files

This document explains how to use Rails Translation Manager to create locale files.

Once you have installed the gem into your application, the expected usage is:

1. export translations to a CSV file using:

   ```
   rake translation:export:all[target_directory]
   ```

   or

   ```
   rake translation:export[target_directory,base_locale,target_locale]
   ```

2. send the appropriate CSV file to a translator

3. wait for translation to happen

4. receive translation file back

5. import the translation file using either:

   ```
   rake translation:import:all[source_directory]
   ```

   or

   ```
   rake translation:import[locale,path]
   ```

   this will generate `.yml` files for each translation

6. commit any changed `.yml` files

   ```
   git add config/locale
   git commit -m 'added new translations'
   ```
