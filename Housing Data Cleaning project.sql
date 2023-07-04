/*
	Author: Sasikanth .D				Date:04-July-2023
	project: Housing Data Cleaning Project
	Discription: To give this data to be clear and accurate to know the each property names and their
				 address, sales Price etc.
*/

-- Let's get Started.

-- 1. Standardize the date formate.

SELECT SaleDate
FROM HousingData

ALTER TABLE HousingData
ADD SaleDateCnv date

UPDATE HousingData
SET SaleDateCnv = CONVERT(date,SaleDate)

SELECT * FROM HousingData

--------------------------------------------------------------------------------------------------------------

-- 2. Split Property Adress Data

SELECT *
FROM HousingData
WHERE PropertyAddress IS NULL

SELECT A.ParcelID, A.propertyAddress, B.ParcelID, B.propertyAddress, ISNULL(A.propertyAddress, B.propertyAddress)
FROM HousingData A 
JOIN HousingData B 
	ON A.ParcelID = B.ParcelID 
	AND A.UniqueID <> B.UniqueID
WHERE A.propertyAddress IS NULL

UPDATE A
SET propertyAddress = ISNULL(A.propertyAddress, B.propertyAddress)
FROM HousingData A 
JOIN HousingData B 
	ON A.ParcelID = B.ParcelID 
	AND A.UniqueID <> B.UniqueID
WHERE A.propertyAddress IS NULL

--------------------------------------------------------------------------------------------------------------

-- 3. Split out the address column

SELECT *
FROM HousingData

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM HousingData

ALTER TABLE HousingData
ADD Address varchar(255)

UPDATE HousingData
SET Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE HousingData
ADD City varchar(255)

UPDATE HousingData
SET City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'), 1) AS State
FROM HousingData


ALTER TABLE HousingData
ADD OwnerSplitAddress varchar(255)

UPDATE HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE HousingData
ADD OwnerSplitCity varchar(255)

UPDATE HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE HousingData
ADD OwnerState varchar(255)

UPDATE HousingData
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

----------------------------------------------------------------------------------------------------------------

-- 4. Change the Y and N to Yes and No in SoldAsVacant column

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM HousingData

UPDATE HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

---------------------------------------------------------------------------------------------------------------

-- 5. Remove Duplicates

WITH DUPLICATE_CTE AS(
SELECT *,
	   ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM HousingData
)
SELECT * 
FROM DUPLICATE_CTE
WHERE row_num > 1

--------------------------------------------------------------------------------------------------------------

-- 6. Delete Unused Columns

SELECT *
FROM HousingData

ALTER TABLE HousingData
DROP COLUMN propertyAddress, OwnerAddress, TaxDistrict, SaleDate

--	THANK YOU! IT'S COMPLETED.